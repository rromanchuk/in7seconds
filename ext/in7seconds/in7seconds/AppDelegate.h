//
//  AppDelegate.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "User.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, LocationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *privateWriterContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) User *currentUser;

//@property (weak, nonatomic) id <ApplicationLifecycleDelegate> delegate;
//@property (strong, nonatomic) NotificationHandler *notificationHandler;
- (void)writeToDisk;
- (void)resetCoreData;
@end
