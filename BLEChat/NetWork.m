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
#define HTTP_IMAGE "http://chat.3fnx.com/chat/open/image/upload.json"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIImageView+AFNetworking.h"
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

-(void) findUserFromId:(NSString*)userid{
    User* user = [[User alloc] init];
    NSString* url_path = [NSString stringWithFormat:@"http://chat.3fnx.com/chat/open/person/%@.json",userid];
    [self.manager GET:url_path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"suc%@",responseObject);
        NSDictionary* ddd = responseObject;
        int code = [[ddd objectForKey:@"code"] intValue];
        if (code!=0) {
            return ;
        }
        NSDictionary* data = [ddd objectForKey:@"data"];
        
        user.age = [[data objectForKey:@"age"] intValue];
        user.userId = [data objectForKey:@"id"];
        user.image = [data objectForKey:@"imagePath"];
        user.name = [data objectForKey:@"name"];
        NSString* sex = [data objectForKey:@"sex"];
        if ([sex isEqualToString:@"male"]) {
            user.sex = YES;
        }else{
            user.sex = NO;
        }
        NSString* status = [data objectForKey:@"status"];
        if ([status isEqualToString:@"ready"]) {
            user.status = YES;
        }else{
            user.status = NO;
        }
        [self.delegate isFindedUserFromId:user];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"ero%@",error);
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
    NSString* sexStr;
    if (user.sex) {
        sexStr = @"male";
    }else{
        sexStr = @"femal";
    }
    NSDictionary* dic = @{@"name":user.name,@"sex":sexStr,@"age":[NSString stringWithFormat:@"%ld",(long)user.age]};
    [self.manager POST:@HTTP_PATH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary* ddd = responseObject;
        
        int code = [[ddd objectForKey:@"code"] intValue];
        if (code!=0) {
            return ;
        }
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
        //        NSString* status = [data objectForKey:@"status"];
        //        if (status) {
        //            if ([status isEqualToString:@"ready"]) {
        //                user.status = YES;
        //            }else{
        //                user.status = NO;
        //            }
        //        }
        user.userId = userId;
        self.globals.mainUser = user;
        [self.delegate isregistered:user];
        
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]==nil){
            [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:sex forKey:@"sex"];
            [[NSUserDefaults standardUserDefaults] setObject:age forKey:@"age"];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) postImage:(UIImage*) image{
    [self.manager POST:@HTTP_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation(image);
        if(imageData == nil)
        {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
        [formData appendPartWithFileData:imageData name:@"imgFile"
                                fileName:@"img.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"suc:%@",responseObject);
        NSDictionary* ddd = responseObject;
        NSDictionary* data = [ddd objectForKey:@"data"];
        self.globals.mainUser.image = [data objectForKey:@"path"];
        [self postUpdateUserInfo];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) postUpdateUserInfo{
    NSDictionary* dic = @{@"imagePath":self.globals.mainUser.image};
    NSString* url_path = [NSString stringWithFormat:@"http://chat.3fnx.com/chat/open/person/%@.json",self.globals.mainUser.userId];
    [self.manager PUT:url_path parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"suc%@",responseObject);
        [self.delegate isLogined];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"ero%@",error);
    }];
}

-(void) changeStateToBusy:(NSString *)userId{
    //NSDictionary* dic = @{@"path":self.globals.mainUser.image};
    NSString* url_path = [NSString stringWithFormat:@"http://chat.3fnx.com/chat/open/person/%@/changeToBusy.json",userId];
    [self.manager PUT:url_path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"suc%@",responseObject);
        NSDictionary* ddd = responseObject;
        NSDictionary* code = [ddd objectForKey:@"code"];
        
        if ([code isEqual:0]) {
            self.globals.mainUser.status = NO;
        }
        [self.delegate isChangedStatu];
        [self.delegate isChangedStatu];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"ero%@",error);
    }];
}

-(void) changeStateToReady:(NSString *)userId{
    //NSDictionary* dic = @{@"path":self.globals.mainUser.image};
    NSString* url_path = [NSString stringWithFormat:@"http://chat.3fnx.com/chat/open/person/%@/changeToReady.json",userId];
    [self.manager PUT:url_path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"suc%@",responseObject);
        NSDictionary* ddd = responseObject;
        NSDictionary* code = [ddd objectForKey:@"code"];
        if ([code isEqual:0]) {
            self.globals.mainUser.status = YES;
        }
        [self.delegate isChangedStatu];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"ero%@",error);
    }];
}


-(void) sendToLike:(NSString *)otherId{
    NSString* url_path = [NSString stringWithFormat:@"http://chat.3fnx.com/chat/open/person/%@/like",otherId];
    NSDictionary* dic = @{@"id":otherId};
    [self.manager PUT:url_path parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"suc%@",responseObject);
        NSDictionary* ddd = responseObject;
        int code = [[ddd objectForKey:@"code"] intValue];
        if (code!=0) {
            return ;
        }
        NSDictionary* data = [ddd objectForKey:@"data"];
        NSString* bothLike = [data objectForKey:@"bothLike"];
        [self.delegate isLiked:[bothLike intValue] :otherId];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"ero%@",error);
    }];
}


-(void) getImageURLFromPath:(User *)user{

}

@end
