//
//  LoginViewController.h
//  BLEChat
//
//  Created by apple on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "NetWork.h"
@interface LoginViewController : UIViewController<LoginViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NetWorkDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) UIPickerView* modePickerView;

@end
