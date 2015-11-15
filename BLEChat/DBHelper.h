//
//  DBHelper.h
//  Christmaslight
//
//  Created by Eleven Chen on 15/8/24.
//  Copyright (c) 2015年 Hunuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DBHelper : NSObject
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

+ (instancetype) sharedInstance;

- (void) save;


@end
