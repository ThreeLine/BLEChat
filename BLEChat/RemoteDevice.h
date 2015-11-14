//
//  RemoteDevice.h
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define WILL_DATE 0x10
#define DATE_OK 0x11
#define DATE_NO 0x12
#define DATE_CANCEL 0x13
#define DATE_DISTANCE 0x14 // 距离

typedef NS_ENUM(NSInteger, RemoteDeviceMsgType)
{
    RemoteDeviceMsgTypeWillDating = 0, // 是否约会
    RemoteDeviceMsgTypeDateCancel,
    RemoteDeviceMsgTypeDateDistance
};

@interface RemoteDevice : NSObject

@property (strong, nonatomic) CBPeripheral* peripheral;
@property (strong, nonatomic) NSString* localName;
@property (strong, nonatomic) NSNumber* RSSI;

// 设置通知
- (void) setNotify:(BOOL) enable;

// 发送消息
- (void) sendMessage:(RemoteDeviceMsgType) msgType data:(NSData*) data;

- (void) readMessage;
@end
