//
//  MMSingleton.h
//  Films
//
//  Created by Admin on 16.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSingleton : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, assign) int buttonPopUpMenu;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (MMSingleton*) sharedInstance;

@end
