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
        self.name = @"5647520d0cf293310d57d478";
        self.delegates = [NSMutableArray array];
    }
    
    return self;
}

- (void) addDelegate:(id<PeripheralManagerDelegate>) delegate
{
    if (![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}


- (void) removeDelegate:(id<PeripheralManagerDelegate>) delegate
{
    [self.delegates removeObject:delegate];
}

- (void) sendMessage:(NSData *)value
{
    [self.manager updateValue:value forCharacteristic:self.notifyCharacteristic onSubscribedCentrals:nil];
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
        
        self.writeCharacteristic =
        [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:WRITE_CHARACTERISTIC_UUID]
                                           properties:(CBCharacteristicPropertyWrite|CBCharacteristicPropertyWriteWithoutResponse)
                                                value:nil
                                          permissions:(CBAttributePermissionsWriteable)];
        
        self.notifyCharacteristic =
        [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:NOTIFY_CHARACTERISTIC_UUID]
                                           properties:(CBCharacteristicPropertyNotify|CBCharacteristicPropertyRead)
                                                value:nil
                                          permissions:(CBAttributePermissionsReadable)];
        
        _service.characteristics = @[self.writeCharacteristic, self.notifyCharacteristic];
        
    }
    
    return _service;
}

#pragma mark - privite methods

- (void) startAdvertising
{
    NSLog(@"startAdvertising %@", self.name);
    for (CBMutableService* service in self.servcies) {
        [self.manager addService:service];
    }
}

- (void) stopAdvertising
{
    NSLog(@"stopAdvertising %@", self.name);
    [self.manager removeAllServices];
    [self.manager stopAdvertising];
}

- (void) sendMessage
{
    uint8_t data[1];
    data[0] = 1;
    NSData * okMessage = [NSData dataWithBytes:data length:1];
    [self.manager updateValue:okMessage forCharacteristic:self.notifyCharacteristic onSubscribedCentrals:nil];
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

- (void) peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didAddService");
    if (!error) {
        NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey : self.name, CBAdvertisementDataServiceUUIDsKey : @[service.UUID]};
        [self.manager startAdvertising:advertisingData];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"didReceiveReadRequest");

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    NSLog(@"didReceiveWriteRequests");
    
    NSArray *delegates = [NSArray arrayWithArray:self.delegates];
    for (id<PeripheralManagerDelegate> delegate in delegates) {
        [delegate peripheral:self didReceiveWriteRequests:requests];
    }
    
//    for (int i = 0; i < [requests count]; i++) {
//        CBATTRequest * request = [requests objectAtIndex:i];
//        NSData *value = request.value;
//        uint8_t data[value.length];
//        [value getBytes:data length:value.length];
//        if (data[0] == 0xff) {
//            [self sendMessage];
//        }
//    }
    
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"didSubscribeToCharacteristic");
    for (id<PeripheralManagerDelegate> delegate in self.delegates) {
        [delegate didSubscribe];
    }
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"didUnsubscribeFromCharacteristic");
    for (id<PeripheralManagerDelegate> delegate in self.delegates) {
        [delegate didUnsubscribe];
    }
}


@end
