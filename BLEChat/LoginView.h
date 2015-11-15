//
//  LoginView.h
//  BLEChat
//
//  Created by apple on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginView;
@protocol LoginViewDelegate <NSObject>
@optional
-(void) sureTouch;
-(void) photoTouch;
-(void) sexTouch;
@end
@interface LoginView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) id<LoginViewDelegate> delegate;
@property(strong) UIImageView* photo;
@property(strong,nonatomic) UITextField* nameField;
@property(strong,nonatomic) UITextField* ageField;
@property(strong) UIButton* sexButton;
@end
