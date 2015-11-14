//
//  PeripheralManager.m
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "PeripheralManager.h"

#define SERVICE_UUID                        @"FFE5"
#define WRITE_CHARACTERISTIC_UUID           @"FFE9"
#define NOTIFY_CHARACTERISTIC_UUID          @"FFE8"

@interface PeripheralManager()
@property (strong, nonatomic) CBPeripheralManager *manager;
@property (strong, nonatomic) CBMutableService *service;
@property (strong, nonatomic) CBMutableCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBMutableCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) NSArray* servcies;
@end

@implementation PeripheralManager

+ (instancetype) peripheralManager
{
    static PeripheralManager *manager;
    if (manager == nil) {
        manager = [[PeripheralManager alloc] init];
    }
    return manager;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        self.enableAdvertising = NO;
    }
    
    return self;
}

- (void) setEnableAdvertising:(BOOL)enableAdvertising
{
    if (_enableAdvertising == enableAdvertising) {
        return;
    }
    _enableAdvertising = enableAdvertising;
    if (self.manager.state == CBPeripheralManagerStatePoweredOn) {
        if (_enableAdvertising) {
            [self startAdvertising];
        } else {
            [self stopAdvertising];
        }
    }
}

- (NSArray*) servcies
{
    if (!_servcies) {
        _servcies = @[self.service];
    }
    return _servcies;
}

- (CBMutableService*) service
{
    if (!_service) {
        _service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:SERVICE_UUID] primary:YES];
        
    }
    
    return _service;
}

#pragma mark - privite methods

- (void) startAdvertising
{
    
}

- (void) stopAdvertising
{
    
}

#pragma mark CBPeripheralManager

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"%s", __FUNCTION__);
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
        {
            if (self.enableAdvertising) {
                NSLog(@"开始广播");
                [self startAdvertising];
            }
            break;
        }
        case CBPeripheralManagerStatePoweredOff:
        {
            if (self.enableAdvertising) {
                NSLog(@"停止广播");
                [self stopAdvertising];
            }
        }
        default:
        {
            NSLog(@"CBPeripheralManager changed state to %d", (int)peripheral.state);
            break;
        }
    }
}


@end
