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
@end
@interface LoginView : UIView
@property (strong, nonatomic) id<LoginViewDelegate> delegate;
@end
