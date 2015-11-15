//
//  AppDelegate.h
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "RemoteDevice.h"
#import "User.h"

typedef NS_ENUM(NSInteger, UserRole)
{
    Unknown = 0,
    PeripheralRole,
    CentralRole
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CBCentralManager* centralManager;
@property (strong, nonatomic) RemoteDevice* currentDevice;
@property (assign, nonatomic) UserRole userRole;
@property (strong, nonatomic) NSMutableArray* remoteDevices;
@property (strong, nonatomic) NSMutableArray* searchedUsers; // 搜索到的用户

- (RemoteDevice*) findRemoteDeviceByUserId:(NSString*) userId;

@end

