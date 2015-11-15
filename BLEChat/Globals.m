//
//  Globals.m
//  BlueLightBase
//
//  Created by Eleven Chen on 15/6/5.
//  Copyright (c) 2015年 Hunuo. All rights reserved.
//

#import "Globals.h"
@interface Globals()

@end
@implementation Globals

+(instancetype) shareInstance
{
    static Globals* _globals = nil;
    if (!_globals) {
        _globals = [[Globals alloc] init];
    }
    return _globals;
}

-(User*) mainUser{
    if (!_mainUser) {
        _mainUser = [[User alloc] init];
    }
    return _mainUser;
}

-(NSMutableArray*) others{
    if (_others) {
        _others = [[NSMutableArray alloc] init];
    }
    return _others;
}



















@end
