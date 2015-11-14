//
//  ViewController.m
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (PeripheralManager*) peripheralManger
{
    if (!_peripheralManger) {
        _peripheralManger = [PeripheralManager peripheralManager];
    }
    return _peripheralManger;
}

- (AppDelegate*) appDelegate
{
    if (!_appDelegate) {
        _appDelegate = [UIApplication sharedApplication].delegate;
    }
    return _appDelegate;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.peripheralManger addDelegate:self];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    [self.peripheralManger removeDelegate:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.appDelegate.currentDevice.peripheral) {
        self.appDelegate.currentDevice.peripheral.delegate = self;
    }
}

- (float) getDistanceFromRSSI:(int) rssi
{
    int iRssi = abs(rssi);
    float power = (iRssi-59)/(10*2.0);
    return pow(10, power);
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}


#pragma mark - PeripheralManagerDelegate

- (void) peripheral:(PeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    if (self.appDelegate.userRole == Unknown) {
        return;
    }
    for (CBATTRequest* request in requests) {
        uint8_t data[request.value.length];
        [request.value getBytes:data length:request.value.length];
        if (data[0] == WILL_DATE) {
            // 询问是否约会
            
        }
    }
}

- (void) didSubscribe
{
    if (self.appDelegate.userRole == Unknown) {
        self.appDelegate.userRole = PeripheralRole;
    }
}

- (void) didUnsubscribe
{
    self.appDelegate.userRole = Unknown;
}

@end
