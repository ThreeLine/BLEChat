//
//  CentralManager.m
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "CentralManager.h"

@interface CentralManager()
@property (strong, nonatomic) CBCentralManager *manager;
@property (assign, nonatomic) BOOL scaning;
@end

@implementation CentralManager

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.delegates = [NSMutableArray array];
        self.nearbyDevcies = [NSMutableArray array];
    }
    return self;
}

+ (instancetype) centralManager
{
    static CentralManager* manager;
    if (manager == nil) {
        manager = [[CentralManager alloc] init];
    }
    return manager;
}

- (void) scanStart
{
    self.scaning = YES;
    if (self.manager.state == CBCentralManagerStatePoweredOn) {
        [self.manager scanForPeripheralsWithServices:nil options:nil];
    }
}


- (void) scanStop
{
    self.scaning = NO;
    [self.manager stopScan];
}

- (void) addDelegate:(id<CentralManagerDelegate>) delegate
{
    if (![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void) removeDelegate:(id<CentralManagerDelegate>) delegate
{
    [self.delegates removeObject:delegate];
}

- (RemoteDevice*) findDevcieByPeripheral:(CBPeripheral*) peripheral
{
    for (RemoteDevice* devcie in self.nearbyDevcies) {
        if (devcie.peripheral == peripheral) {
            return devcie;
        }
    }
    return nil;
}

#pragma mark - CBCenterManagerDelegate
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState %ld", (long)central.state);
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            if (self.scaning) {
                [self scanStart];
            }
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            if (self.scaning) {
                [self scanStop];
            }
            break;
        }
        default:
            break;
    }
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([self findDevcieByPeripheral:peripheral]) {
        return;
    }
    RemoteDevice* devcie = [[RemoteDevice alloc] init];
    devcie.peripheral = peripheral;
    devcie.localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (!devcie.localName) {
        devcie.localName = @"Unknown";
    }
    devcie.RSSI = RSSI;
    [self.nearbyDevcies addObject:devcie];
    for (id<CentralManagerDelegate> delegate in self.delegates) {
        [delegate central:self didDiscoverPeripheral:devcie];
    }
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    for (id<CentralManagerDelegate> delegate in self.delegates) {

    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

@end
