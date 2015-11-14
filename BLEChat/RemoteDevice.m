//
//  RemoteDevice.m
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "RemoteDevice.h"
#define SERVICE_UUID                        @"FFE5"
#define WRITE_CHARACTERISTIC_UUID           @"FFE9"
#define NOTIFY_CHARACTERISTIC_UUID          @"FFE8"

@implementation RemoteDevice

- (CBService*) findServiceByUUID:(CBUUID*) UUID inPeripheral:(CBPeripheral*) peripheral
{
    for (CBService* s in peripheral.services) {
        NSLog(@"s UUID %@", s.UUID.UUIDString);
        if ([s.UUID.UUIDString isEqualToString:UUID.UUIDString]) {
            return s;
        }
    }
    return nil;
}

- (CBCharacteristic*) findCharacteristicByUUID:(CBUUID* ) UUID inService:(CBService*) service
{
    for (CBCharacteristic* c in service.characteristics) {
        if ([c.UUID.UUIDString isEqualToString: UUID.UUIDString]) {
            return c;
        }
    }
    return nil;
}

// 设置通知
- (void) setNotify:(BOOL) enable
{
    CBService *s = [self findServiceByUUID:[CBUUID UUIDWithString:SERVICE_UUID] inPeripheral:self.peripheral];
    if (!s) {
        NSLog(@"Servcie is nil");
        return ;
    }
    CBCharacteristic* c = [self findCharacteristicByUUID:[CBUUID UUIDWithString:NOTIFY_CHARACTERISTIC_UUID] inService:s];
    if (!c) {
        NSLog(@"Characteristic is nil");
        return;
    }
    [self.peripheral setNotifyValue:enable forCharacteristic:c];
}

// 发送消息
- (void) sendMessage:(RemoteDeviceMsgType) msgType data:(NSData*) data
{
    uint8_t value[1];
    if (msgType == RemoteDeviceMsgTypeWillDating) {
        NSLog(@"询问是否约会");
        value[0] = WILL_DATE;
    }
    if (msgType == RemoteDeviceMsgTypeDateCancel) {
        NSLog(@"取消约会");
        value[0] = DATE_CANCEL;
    }
    if (msgType == RemoteDeviceMsgTypeDateDistance) {
        NSLog(@"距离");
        value[0] = DATE_DISTANCE;
    }
    CBService *s = [self findServiceByUUID:[CBUUID UUIDWithString:SERVICE_UUID] inPeripheral:self.peripheral];
    if (!s) {
        NSLog(@"Servcie is nil");
        return ;
    }
    CBCharacteristic* c = [self findCharacteristicByUUID:[CBUUID UUIDWithString:WRITE_CHARACTERISTIC_UUID] inService:s];
    if (!c) {
        NSLog(@"Characteristic is nil");
        return;
    }
    if (data == nil) {
        // 发送
        [self.peripheral writeValue:[NSData dataWithBytes:value length:1] forCharacteristic:c type:CBCharacteristicWriteWithoutResponse];
    } else {
        uint8_t newData[data.length + 1];
        uint8_t b[data.length];
        [data getBytes:b length:data.length];
        newData[0] = value[0];
        for (int i = 0, j = 1; i < data.length; i++, j++) {
            newData[j] = b[i];
        }
        [self.peripheral writeValue:[NSData dataWithBytes:newData length:data.length+1] forCharacteristic:c type:CBCharacteristicWriteWithoutResponse];
    }
    

}

- (void) readMessage
{
    NSLog(@"readMessage");
    CBService *s = [self findServiceByUUID:[CBUUID UUIDWithString:SERVICE_UUID] inPeripheral:self.peripheral];
    if (!s) {
        NSLog(@"Servcie is nil");
        return ;
    }
    CBCharacteristic* c = [self findCharacteristicByUUID:[CBUUID UUIDWithString:NOTIFY_CHARACTERISTIC_UUID] inService:s];
    if (!c) {
        NSLog(@"Characteristic is nil");
        return;
    }
    [self.peripheral readValueForCharacteristic:c];

}

@end
