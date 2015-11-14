//
//  DBHelper.m
//  Christmaslight
//
//  Created by Eleven Chen on 15/8/24.
//  Copyright (c) 2015年 Hunuo. All rights reserved.
//

#import "DBHelper.h"

static DBHelper* instance;
@interface DBHelper()
@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@end
@implementation DBHelper

+ (instancetype) sharedInstance
{
    if (!instance) {
        instance = [[DBHelper alloc] init];
    }
    
    return instance;
}

- (NSURL*) applicationDocumentDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask].lastObject;
}

#pragma mark - getter/setter
- (NSManagedObjectContext*) mainContext
{
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc] init];
        [_mainContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _mainContext;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"Christmaslight.sqlite"];
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"%@", [error localizedDescription]);
            abort();
        }
        
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel*) managedObjectContext
{
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Christmaslight" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

#pragma mark - public api
- (void) save
{
    if (self.mainContext) {
        NSError *error;
        if ([self.mainContext hasChanges] && ![self.mainContext save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}


@end
