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
#define IMAGE_URL @"http://resource.3fnx.com/images/DhSPH"
@class NetWork;
@protocol NetWorkDelegate <NSObject>
@optional
-(void) isFindedUserFromId:(User*) user;
-(void) isLogined;
-(void) isregistered:(User*) user;
-(void) isChangedStatu;
-(void) isLiked:(BOOL) isSuc :(NSString*)otherId;
@end
@interface NetWork : NSObject
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(strong, nonatomic) id<NetWorkDelegate>delegate;

-(void) registerUser:(User*) user;

-(void) login:(User*) user;

-(void) findUserFromId:(NSString*) userid;//通过id查找用户

-(void) get;

-(void) postImage:(UIImage*) image;

-(void) changeStateToBusy:(NSString*) userId;

-(void) changeStateToReady:(NSString*) userId;;

-(void) getImageURLFromPath:(User*) user;

-(void) sendToLike:(NSString*) otherId;

@end
