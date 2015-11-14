//
//  NetWork.h
//  BLEChat
//
//  Created by apple on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "User.h"
@class NetWork;
@protocol NetWorkDelegate <NSObject>
@optional
-(void) isFindedUserFromId:(User*) user;
-(void) isLogined;
-(void) isregistered:(User*) user;
@end
@interface NetWork : NSObject
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(strong, nonatomic) id<NetWorkDelegate>delegate;

-(void) registerUser:(User*) user;

-(void) login:(User*) user;

-(void) findUserFromId:(NSInteger) userid;//通过id查找用户

-(void) get;
@end
