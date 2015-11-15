//
//  WaitingViewController.m
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "WaitingViewController.h"
#import "RadarView.h"

@interface WaitingViewController () <CBCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet RadarView *radarView;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (assign,nonatomic) NSInteger discoverServiceCount;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger count;

@end

@implementation WaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.appDelegate.userRole == CentralRole) {
        self.yesButton.hidden = YES;
        self.timerLabel.hidden = YES;
    }
    // 60s倒计时
    self.count = 60;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.radarView startAnimation];
    
    if (self.appDelegate.userRole == CentralRole) {
        [self connectToUser];
        // 显示对方的图片
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL,[Globals shareInstance].other.image]];
        [self.radarView.imageView setImageWithURL:url];
        self.messageLabel.text = @"Waiting to be accept";
    } else if (self.appDelegate.userRole == PeripheralRole) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        self.messageLabel.text = @"Close to her?";
    }
    
}

- (void) countDown:(NSTimer*) timer
{
    self.count--;
    self.timerLabel.text = [NSString stringWithFormat:@"%ld s", self.count];
    if (self.count == 0) {
        [self rejectDate];
    }
}

- (void) acceptDate
{
    NSLog(@"同意约会");
    uint8_t data[1];
    data[0] = DATE_OK;
    NSLog(@"%x", data[0]);
    [self.peripheralManger sendMessage:[NSData dataWithBytes:data length:1]];
    [self performSegueWithIdentifier:@"ShowCloseToUserSegue" sender:self];
}

- (void) rejectDate
{
    NSLog(@"被残忍拒绝");
    uint8_t data[1];
    data[0] = DATE_NO;
    [self.peripheralManger sendMessage:[NSData dataWithBytes:data length:1]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CentralRole
- (void) connectToUser
{
    self.appDelegate.centralManager.delegate = self;
    [self.appDelegate.centralManager connectPeripheral:self.appDelegate.currentDevice.peripheral options:nil];
}

- (void) beAcceptDate
{
    NSLog(@"对方同意约会");
    [self performSegueWithIdentifier:@"ShowCloseToUserSegue" sender:self];
    self.appDelegate.userRole = CentralRole;
}

- (void) beRejectDate
{
    NSLog(@"对方拒绝约会");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) discoverFinish
{
    NSLog(@"discoverFinish");
    // 设置监听
    [self.appDelegate.currentDevice setNotify:YES];
    
    NSString* userId =[Globals shareInstance].mainUser.userId;
    uint8_t name[userId.length];
    for (int i = 0; i < userId.length; i++) {
        name[i] = [userId characterAtIndex:i];
    }
    NSData* value = [NSData dataWithBytes:name length:userId.length];
    
    // 询问是否接受邀请
    [self.appDelegate.currentDevice sendMessage:RemoteDeviceMsgTypeWillDating data:value];
}


#pragma mark - CBPeripheralDelegate

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    self.discoverServiceCount = [peripheral.services count];
    if (!error) {
        for (CBService* service in peripheral.services) {
            NSLog(@"service UUID %@", service.UUID.UUIDString);
            [peripheral discoverCharacteristics:nil forService:service];
            
        }
    } else {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        self.discoverServiceCount--;
        if (self.discoverServiceCount == 0) {
            [self discoverFinish];
        }
    } else {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

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
        if (data[0] == DATE_OK) {
            // 同意约会
            [self beAcceptDate];
        } else {
            // 不同意约会
            [self beRejectDate];
        }
        
        //[self.appDelegate.currentDevice readMessage];
        
    } else {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Connect fail." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [self dismissViewControllerAnimated:YES completion:nil];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Her/He cancel." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}



- (IBAction)onNoButtonClick:(id)sender
{
    if (self.appDelegate.userRole == CentralRole) {
        [self.appDelegate.currentDevice sendMessage:RemoteDeviceMsgTypeDateCancel data:nil];
        [self.appDelegate.centralManager cancelPeripheralConnection:self.appDelegate.currentDevice.peripheral];
        self.appDelegate.currentDevice = nil;
        self.appDelegate.userRole = Unknown;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (self.appDelegate.userRole == PeripheralRole) {
        [self rejectDate];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onOkButtonClick:(id)sender
{
    if (self.appDelegate.userRole == CentralRole) {
        
    } else {
        [self acceptDate];
    }
}


@end
