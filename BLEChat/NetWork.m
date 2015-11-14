//
//  NetWork.m
//  BLEChat
//
//  Created by apple on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "NetWork.h"
#import "Globals.h"
#define HTTP_PATH "http://chat.3fnx.com/chat/open/person/basic.json"
#import "AFNetworkActivityIndicatorManager.h"
@interface NetWork()
@property (strong, nonatomic) Globals* globals;
@end
@implementation NetWork

- (Globals*) globals
{
    if (!_globals) {
        _globals = [Globals shareInstance];
    }
    return _globals;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(AFHTTPRequestOperationManager*) manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _manager.requestSerializer = serializer;
    }
    return _manager;
}



-(void) post:(NSDictionary*) parm
{
    [self.manager POST:@HTTP_PATH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) get{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@HTTP_PATH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) findUserFromId:(NSInteger)userid{
    User* user = [[User alloc] init];
    NSDictionary* dic = nil;
    [self.manager POST:@HTTP_PATH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self.delegate isFindedUserFromId:user];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) login:(User *)user{
    NSDictionary* dic = nil;
    [self.manager POST:@HTTP_PATH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self.delegate isLogined];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) registerUser:(User *)user{
    NSDictionary* dic = @{@"name":@"xiaoxiao",@"sex":@"male",@"age":@"18"};
    [self.manager POST:@HTTP_PATH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary* ddd = responseObject;
        NSString* code = [ddd objectForKey:@"code"];
        NSDictionary* data = [ddd objectForKey:@"data"];
        
        NSString* age = [data objectForKey:@"age"];
        NSString* userId = [data objectForKey:@"id"];
        NSString* imgPath = [data objectForKey:@"imagePath"];
        NSString* name = [data objectForKey:@"name"];
        NSString* sex = [data objectForKey:@"sex"];
        
        NSString* debugInfo = [ddd objectForKey:@"debugInfo"];
        NSString* msg = [ddd objectForKey:@"msg"];
        User* user = [[User alloc] init];
        user.name = name;
        user.age = [age intValue];
        if ([sex isEqualToString:@"male"]) {
            user.sex = YES;
        }else{
            user.sex = NO;
        }
        user.userId = userId;
        self.globals.mainUser = user;
        [self.delegate isregistered:user];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) postImage{
    
}


@end
