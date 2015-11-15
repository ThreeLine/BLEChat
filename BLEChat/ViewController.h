//
//  ViewController.h
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeripheralManager.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "NetWork.h"

@interface ViewController : UIViewController<PeripheralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) PeripheralManager* peripheralManger;
@property (strong, nonatomic) AppDelegate* appDelegate;

- (float) getDistanceFromRSSI:(int) rssi;
@end

