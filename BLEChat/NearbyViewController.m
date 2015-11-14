//
//  NearbyViewController.m
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "NearbyViewController.h"
#import "PeripheralManager.h"
#import "RemoteDevice.h"
#import "DraggableView.h"
#import "ECExtension.h"
#import "WaitingViewController.h"

#define ALERT_VIEW_TAG_ASK_WILL_DATE 1000 // 是否约会对话框
#define ALERT_VIEW_WAITING 1001 // 等待对话框

@interface NearbyViewController ()<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, DraggableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* remoteDevices;
@property (assign,nonatomic) NSInteger discoverServiceCount;
@property (strong, nonatomic) UIAlertView *waitingAlertView;
@property (weak, nonatomic) IBOutlet UIView *swipeViewContainer;

@property (strong, nonatomic) NSMutableArray* allCards;
@property (assign, nonatomic) NSInteger lastCardIndex; // 最后卡片的位置


@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate.remoteDevices = [NSMutableArray array];
    
    self.peripheralManger.enableAdvertising = YES;
    self.appDelegate.centralManager.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    //[self loadCards];
    self.allCards = [NSMutableArray array];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadCards];

    if (self.appDelegate.centralManager.state== CBCentralManagerStatePoweredOn) {
        [self.appDelegate.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @(YES)}];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.appDelegate.centralManager stopScan];
}

- (void) loadCards
{
    [self.allCards removeAllObjects];
    [self.swipeViewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview )];
    for (int i = 0; i < [self.appDelegate.remoteDevices count]; i++) {
        [self addCard];
    }
//    
//    for (NSInteger i = [self.appDelegate.remoteDevices count]-1; i >= 0; i--) {
//        [self.swipeViewContainer bringSubviewToFront:self.allCards[i]];
//    }
}

- (void) addCard
{
    //return;
    NSLog(@"addCard");
    RemoteDevice* device = [self.appDelegate.remoteDevices objectAtIndex:self.lastCardIndex];
    
    DraggableView *card = [[DraggableView alloc] init];
    card.tag = self.lastCardIndex;
    card.delegate = self;
    card.userInfoLabel.text = device.localName;
    DraggableView* lastView = nil;
    if ([self.allCards count] > 0) {
        lastView = [self.allCards lastObject];
    }
    if (lastView) {
        [self.swipeViewContainer insertSubview:card belowSubview:lastView];
    } else {
        [self.swipeViewContainer addSubview:card];
    }
    card.translatesAutoresizingMaskIntoConstraints = NO;
    [card layoutMatchSuperView];
    [self.allCards addObject:card];
    
    self.lastCardIndex = (self.lastCardIndex+1) % [self.appDelegate.remoteDevices count];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.swipeViewContainer];
}

- (DraggableView*) createCardAtIndex:(NSInteger) index;
{
    DraggableView *card = [[DraggableView alloc] init];
    card.delegate = self;
    card.information.text = [NSString stringWithFormat:@"Card %d", index];
    return card;
}

- (RemoteDevice*) findDevcieByPeripheral:(CBPeripheral*) peripheral
{
    for (RemoteDevice* devcie in self.appDelegate.remoteDevices) {
        if (devcie.peripheral == peripheral) {
            return devcie;
        }
    }
    return nil;
}

- (CBService*) findServiceByUUID:(CBUUID*) UUID inPeripheral:(CBPeripheral*) peripheral
{
    for (CBService* s in peripheral.services) {
        if (s.UUID == UUID) {
            return s;
        }
    }
    return nil;
}

- (CBCharacteristic*) findCharacteristicByUUID:(CBUUID* ) UUID inService:(CBService*) service
{
    for (CBCharacteristic* c in service.characteristics) {
        if (c.UUID == UUID) {
            return c;
        }
    }
    return nil;
}

- (void) discoverFinish
{
    NSLog(@"discoverFinish");
    // 设置监听
    [self.appDelegate.currentDevice setNotify:YES];
    
    // 询问是否接受邀请
    [self.appDelegate.currentDevice sendMessage:RemoteDeviceMsgTypeWillDating data:nil];
    [self showWaitingDialog];
}

#pragma mark - PeripheralRole
- (void) acceptDate
{
    NSLog(@"同意约会");
    uint8_t data[1];
    data[0] = DATE_OK;
    NSLog(@"%x", data[0]);
    [self.peripheralManger sendMessage:[NSData dataWithBytes:data length:1]];
}

- (void) rejectDate
{
    NSLog(@"被残忍拒绝");
    uint8_t data[1];
    data[0] = DATE_NO;
    [self.peripheralManger sendMessage:[NSData dataWithBytes:data length:1]];
}

- (void) showAskDateDialog
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"XXX want to date with you" delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
    alertView.tag = ALERT_VIEW_TAG_ASK_WILL_DATE;
    [alertView show];
}

#pragma mark - CentralRole
- (void) beAcceptDate
{
    NSLog(@"对方同意约会");
    self.waitingAlertView.message = @"对方同意约会";
}

- (void) beRejectDate
{
    NSLog(@"对方拒绝约会");
    self.waitingAlertView.message = @"对方同意约会";
}

- (void) showWaitingDialog
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Wating..." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    alertView.tag = ALERT_VIEW_WAITING;
    [alertView show];
    self.waitingAlertView = alertView;
}

- (void) connectToRemoteDevice:(RemoteDevice*) device
{
    [self.appDelegate.centralManager connectPeripheral:device.peripheral options:nil];
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
    if (central.state == CBCentralManagerStatePoweredOn) {
        [central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @(YES)}];
    } else if (central.state == CBCentralManagerStatePoweredOff) {
        [central stopScan];
    }
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    RemoteDevice* devcie = [self findDevcieByPeripheral:peripheral];
    if (devcie) {
        return;
    }
    devcie = [[RemoteDevice alloc] init];
    devcie.peripheral = peripheral;
    devcie.localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (!devcie.localName) {
        devcie.localName = @"Unknown";
    }
    [self.appDelegate.remoteDevices addObject:devcie];
    NSLog(@"discover peripheral %@", devcie.localName);
    // 更新卡片
    [self addCard];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    RemoteDevice *device = [self findDevcieByPeripheral:peripheral];
    self.appDelegate.currentDevice = device;
    
    [peripheral discoverServices:nil];
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // 重新连接
    [central connectPeripheral:peripheral options:nil];
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // 连接失败
    NSLog(@"connect fail!!!");
    self.appDelegate.currentDevice = nil;
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


#pragma mark - PeripheralManagerDelegate

- (void) peripheral:(PeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    [super peripheral:peripheral didReceiveWriteRequests:requests];
    for (CBATTRequest* request in requests) {
        uint8_t data[request.value.length];
        [request.value getBytes:data length:request.value.length];
        if (data[0] == WILL_DATE) {
            // 询问是否约会
            [self performSegueWithIdentifier:@"ShowWaitingSegue" sender:self];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_VIEW_TAG_ASK_WILL_DATE) {
        if (buttonIndex == 0) {
            // 拒绝
            [self rejectDate];
        } else if (buttonIndex == 1) {
            // 同意
            [self acceptDate];
        }
    } else if (alertView.tag == ALERT_VIEW_WAITING) {
        if (buttonIndex == 0) {
            NSLog(@"用户主动取消等待");
            [self.appDelegate.centralManager cancelPeripheralConnection:self.appDelegate.currentDevice.peripheral];
            self.appDelegate.currentDevice = nil;
        }
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appDelegate.remoteDevices count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Device" forIndexPath:indexPath];
    RemoteDevice *device = self.appDelegate.remoteDevices[indexPath.row];
    cell.textLabel.text = device.localName;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemoteDevice *device = self.appDelegate.remoteDevices[indexPath.row];
    [self.appDelegate.centralManager connectPeripheral:device.peripheral options:nil];
    self.appDelegate.currentDevice = device;
}

#pragma mark - DraggableViewDelegate
-(void)cardSwipedLeft:(UIView *)card
{
    DraggableView* dragView = (DraggableView*) card;
    [self.allCards removeObject:card];
    //[self addCard];
    if ([self.allCards count] == 0) {
        [self loadCards];
    }
    
    RemoteDevice* device = self.appDelegate.remoteDevices[dragView.tag];
    NSLog(@"unlike device name %@, tag %d", device.localName, dragView.tag);
}
-(void)cardSwipedRight:(UIView *)card
{
    DraggableView* dragView = (DraggableView*) card;
    [self.allCards removeObject:card];
    //[self addCard];
    if ([self.allCards count] == 0) {
        [self loadCards];
    }
    
    // 假设对方也喜欢
    RemoteDevice* device = self.appDelegate.remoteDevices[dragView.tag];
    NSLog(@"like device name %@ tag %d", device.localName, dragView.tag);
    self.appDelegate.currentDevice = device;
    self.appDelegate.userRole = CentralRole;
    [self performSegueWithIdentifier:@"ShowWaitingSegue" sender:self];
}
#pragma mark - Events
- (IBAction)onUnlikeClicked:(id)sender
{
    DraggableView *dragView = [self.allCards firstObject];
//    DraggableView *dragView = [self.swipeViewContainer.subviews firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}
- (IBAction)onLikeClicked:(id)sender
{
    if ([self.allCards count] == 0) {
        return;
    }
    DraggableView *dragView = [self.allCards firstObject];
//    DraggableView *dragView = [self.swipeViewContainer.subviews firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
    
    

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowWaitingSegue"]) {
        WaitingViewController *vc = (WaitingViewController*)segue.destinationViewController;
    }
}

@end
