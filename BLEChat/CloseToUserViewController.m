//
//  CloseToUserViewController.m
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "CloseToUserViewController.h"
#import "RadarView.h"

@interface CloseToUserViewController () <CBCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet RadarView *remoteUserRadaView;
@property (weak, nonatomic) IBOutlet RadarView *myReadarView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSTimer* timer;

@end

@implementation CloseToUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.remoteUserRadaView startAnimation];
    [self.myReadarView startAnimation];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(readRSSI:) userInfo:nil repeats:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void) readRSSI:(NSTimer*) timer
{
    [self.appDelegate.currentDevice.peripheral readRSSI];
}

- (void) updateDistance:(int) distance
{
    self.distanceLabel.text = [NSString stringWithFormat:@"%d m", distance];
}

- (IBAction)onCancelButtonTouched:(id)sender
{
    // 双方发送取消消息
    if (self.appDelegate.userRole == CentralRole) {
        [self.appDelegate.currentDevice sendMessage:RemoteDeviceMsgTypeDateCancel data:nil];
        [self.appDelegate.centralManager cancelPeripheralConnection:self.appDelegate.currentDevice.peripheral];
        self.appDelegate.currentDevice = nil;
    } else {
        uint8_t data[1];
        data[0] = DATE_CANCEL;
        [self.peripheralManger sendMessage:[NSData dataWithBytes:data length:1]];
    }
    [self performSegueWithIdentifier:@"ShowNearbySegue" sender:self];
}

#pragma mark - PeripheralManagerDelegate
- (void) peripheral:(PeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    [super peripheral:peripheral didReceiveWriteRequests:requests];
    for (CBATTRequest* request in requests) {
        uint8_t data[request.value.length];
        NSLog(@"receive data length: %d", request.value.length);
        [request.value getBytes:data length:request.value.length];
        if (data[0] == DATE_CANCEL) {
            // 取消约会
            [self performSegueWithIdentifier:@"ShowNearbySegue" sender:self];
        } else if(data[0] == DATE_DISTANCE) {
            [self updateDistance:data[1]];
        }
    }

}

- (void) didUnsubscribe
{
    [super didUnsubscribe];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.appDelegate.userRole != PeripheralRole) {
            [self performSegueWithIdentifier:@"ShowNearbySegue" sender:self];
        }
    });
}

#pragma mark - CBCentralManagerDelegate
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");

}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral discoverServices:nil];
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // 重新连接
    if (self.appDelegate.currentDevice) {
        [central connectPeripheral:peripheral options:nil];
    } else {
        NSLog(@"用户断开的连接");
    }
    
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // 连接失败
    NSLog(@"connect fail!!!");
    self.appDelegate.currentDevice = nil;
    [self performSegueWithIdentifier:@"ShowNearbySegue" sender:self];
}

#pragma mark - CBPeripheralDelegate
- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateValue");
    if (!error) {
        NSData *value = characteristic.value;
        uint8_t data[value.length];
        [value getBytes:data length:value.length];
        for (int i = 0; i < value.length; i++) {
            NSLog(@"data[%d] = %x",i, data[i]);
        }
        //        NSLog(@"%x", data[0]);
        if (data[0] == DATE_CANCEL) {
            NSLog(@"约会取消");
            [self performSegueWithIdentifier:@"ShowNearbySegue" sender:self];
        }

    } else {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    if (!error) {
        NSLog(@"RSSI %d", [RSSI intValue]);
        int dis = (int)[self getDistanceFromRSSI:[RSSI intValue]];
        uint8_t data[1];
        data[0] = (uint8_t)dis;
        [self.appDelegate.currentDevice sendMessage:RemoteDeviceMsgTypeDateDistance data:[NSData dataWithBytes:data length:1]];
        
        [self updateDistance:dis];
    } else {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}



@end
