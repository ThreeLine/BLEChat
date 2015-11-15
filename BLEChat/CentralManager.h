//
//  CentralManager.h
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "RemoteDevice.h"
@class CentralManager;

@protocol CentralManagerDelegate <NSObject>

- (void) central:(CentralManager*)manager didDiscoverPeripheral:(RemoteDevice*) remoteDevcie;

- (void) central:(CentralManager*) manager didConnectPeripheral:(RemoteDevice*) removeDevice;

- (void) central:(CentralManager*) manager didDisConnectPeripheral:(RemoteDevice*) removeDevcie;

- (void) central:(CentralManager*) manager didFailConnectPeripheral:(RemoteDevice*) removeDevcie;

@end

@interface CentralManager : NSObject<CBCentralManagerDelegate>
@property (strong, nonatomic) NSMutableArray *delegates;
@property (strong, nonatomic) NSMutableArray *nearbyDevcies; // 附件的设备
@property (strong, nonatomic) RemoteDevice* connectedDevcie; // 已经连接上的设备

+ (instancetype) centralManager;

/**
 * 开始扫描
 */
- (void) scanStart;

/**
 * 停止扫描
 */
- (void) scanStop;

- (void) addDelegate:(id<CentralManagerDelegate>) delegate;

- (void) removeDelegate:(id<CentralManagerDelegate>) delegate;

- (RemoteDevice*) findDevcieByPeripheral:(CBPeripheral*) peripheral;

@end
