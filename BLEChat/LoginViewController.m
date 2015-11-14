//
//  LoginViewController.m
//  BLEChat
//
//  Created by apple on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "NetWork.h"
@interface LoginViewController ()
@property(nonatomic,strong) LoginView* loginview;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginview = [[LoginView alloc] init];
    self.loginview.delegate = self;
    self.view = self.loginview;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sureTouch{
    NetWork* work = [[NetWork alloc] init];
    [work registerUser:nil];
    //[work get];
    NSLog(@"sdsd");
};
@end
