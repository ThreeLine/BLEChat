//
//  PeripheralManager.h
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class PeripheralManager;
@protocol PeripheralManagerDelegate <NSObject>

/**
 * 收到写的请求
 */
- (void) peripheral:(PeripheralManager*) peripheral didReceiveWriteRequests:(NSArray *)requests;

- (void) didSubscribe;

- (void) didUnsubscribe;

@end

@interface PeripheralManager : NSObject<CBPeripheralManagerDelegate>
@property (strong, nonatomic) CBMutableService *service;
@property (strong, nonatomic) CBMutableCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBMutableCharacteristic *notifyCharacteristic;
/**
 * 是否允许广播
 */
@property (assign, nonatomic) BOOL enableAdvertising;
@property (assign, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray* delegates;


+ (instancetype) peripheralManager;

/**
 * 像Central发送信息
 */
- (void) sendMessage: (NSData*) value;

/**
 * 加入一个Delegate
 */
- (void) addDelegate:(id<PeripheralManagerDelegate>) delegate;

/**
 * 移除一个Delegate
 */
- (void) removeDelegate:(id<PeripheralManagerDelegate>) delegate;

@end
