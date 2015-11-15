//
//  User.h
//  BLEChat
//
//  Created by apple on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface User : NSObject
@property(nonatomic) NSString* name;
@property(nonatomic) BOOL sex;//0为女1为男
@property(nonatomic) BOOL status;//0为busy1为ready
@property(nonatomic) NSString* image;
@property(nonatomic) NSInteger age;
@property(nonatomic) NSString* userId;
@property(nonatomic) UIImage* uiimage;
@end
