//
//  PeripheralManager.h
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralManager : NSObject<CBPeripheralManagerDelegate>

+ (instancetype) peripheralManager;

/**
 * 是否允许广播
 */
@property (assign, nonatomic) BOOL enableAdvertising;

@end
