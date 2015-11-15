//
//  Globals.h
//  BlueLightBase
//
//  Created by Eleven Chen on 15/6/5.
//  Copyright (c) 2015年 Hunuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Globals : NSObject
+(instancetype) shareInstance;
@property(nonatomic,strong) User* mainUser;//主角
@property(nonatomic,strong) NSMutableArray* others;//扫描到的其他用户
@end
