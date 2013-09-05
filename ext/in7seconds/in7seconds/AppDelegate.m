//
//  AppDelegate.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "AppDelegate.h"
#import "InitialViewController.h"
#import "User+REST.h"
#import <Crashlytics/Crashlytics.h>
#import "UAPush.h"
#import "UAirship.h"
#import "UAConfig.h"
#import "Config.h"
#import "Facebook.h"
#import "Appirater.h"
#import "RestHookup.h"
#import "Hookup+REST.h"
#import "NotificationHandler.h"
#import "RestNotification.h"
#import "Notification+REST.h"

@implementation AppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize privateWriterContext = __privateWriterContext;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"604460636"];
    
    // Override point for customization after application launch.
    [Flurry startSession:@"7RBHDYVR2RPTKP7NT4XN"];
    [TestFlight takeOff:@"8b9f2759-9e2b-48d9-873b-d3af3677d35b"];
    [Crashlytics startWithAPIKey:@"cbbca2d940f872c4617ddb67cf20ec9844d036ea"];
    
    UAConfig *config = [UAConfig defaultConfig];
    config.developmentAppKey = [Config sharedConfig].airshipKeyDev;
    config.developmentAppSecret = [Config sharedConfig].airshipSecretDev;
    config.productionAppKey = [Config sharedConfig].airshipKeyProd;
    config.productionAppSecret = [Config sharedConfig].airshipSecretProd;

    

    
    [UAirship takeOff:config];
    [[UAPush shared] setPushEnabled:YES];
    [UAPush shared].delegate = [NotificationHandler shared];
    [[UAPush shared] setAutobadgeEnabled:YES];

    // Set the icon badge to zero on startup (optional)
    [[UAPush shared] resetBadge];
    
    // Register for remote notfications with the UA Library. This call is required.
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];
    
    // Handle any incoming incoming push notifications.
    // This will invoke `handleBackgroundNotification` on your UAPushNotificationDelegate.
    [[UAPush shared] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                       applicationState:application.applicationState];
    
    
    [Location sharedLocation].delegate = self;
    self.initalStoryboard = self.window.rootViewController.storyboard;
    
    self.currentUser = [User currentUser:self.managedObjectContext];
    [self theme];
    
    [FBAppEvents activateApp];
    
    [Appirater setAppId:@"604460636"];
    //[Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:4];
    //[Appirater setSignificantEventsUntilPrompt:-1];
    //[Appirater setTimeBeforeReminding:2];
    //[Appirater setDebug:YES];
    
    [Appirater appLaunched:YES];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.delegate applicationWillExit];
    [self writeToDisk];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.delegate applicationWillWillStart];
    [FBSession.activeSession handleDidBecomeActive];
    
    [Location sharedLocation].delegate = self;
    [[Location sharedLocation] updateUntilDesiredOrTimeout:15.0];
    
    if (self.currentUser) {
        [NotificationHandler shared].currentUser = self.currentUser;
        [NotificationHandler shared].managedObjectContext = self.managedObjectContext;

        [self.managedObjectContext performBlock:^{
            [RestUser reload:^(RestUser *restUser) {
                NSString *alias = [NSString stringWithFormat:@"%d", restUser.externalId];
                [[UAPush shared] setAlias:alias];
                [[UAPush shared] updateRegistration];
                self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
                
                NSError *error;
                [self.managedObjectContext save:&error];
                [self writeToDisk];
                [self fetchHookups];
            } onError:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];

        }];
        
    }
}

- (void)fetchHookups {
//    [self.managedObjectContext performBlock:^{
//        [RestHookup load:^(NSMutableArray *possibleHookups) {
//            NSMutableSet *_restHookups = [[NSMutableSet alloc] init];
//            for (RestHookup *restHookup in possibleHookups) {
//                [_restHookups addObject:[Hookup hookupWithRestHookup:restHookup inManagedObjectContext:self.managedObjectContext]];
//            }
//            [self.currentUser addHookups:_restHookups];
//            
//            NSError *error;
//            [self.managedObjectContext save:&error];
//            [self writeToDisk];
//            
//            
//        } onError:^(NSError *error) {
//            
//        }];
//    }];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)theme {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    navigationBarAppearance.titleTextAttributes = @{UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0],
                                                   UITextAttributeTextColor: RGBACOLOR(50, 57, 61, 1.0),
                                                   UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]};
}

- (void)writeToDisk {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.privateWriterContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            [Flurry logError:@"FAILED_CONTEXT_SAVE" message:[error description] error:error];
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            [Flurry logError:@"FAILED_CONTEXT_SAVE" message:[error description] error:error];
            ALog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    [self writeToDisk];
}

- (void)resetCoreData {
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"in7seconds.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    __persistentStoreCoordinator = nil;
    __managedObjectContext = nil;
    __managedObjectModel = nil;
    __privateWriterContext = nil;
    InitialViewController *vc = (InitialViewController *)self.window.rootViewController;
    vc.managedObjectContext = self.managedObjectContext;
    vc.currentUser = [User currentUser:self.managedObjectContext];
    
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __privateWriterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [__privateWriterContext setPersistentStoreCoordinator:coordinator];
        
        // create main thread MOC
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        __managedObjectContext.parentContext = __privateWriterContext;
        
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"in7seconds" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"in7seconds.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        [__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        [Flurry logError:@"FAILED_PERSISTENT_STORE" message:[error description] error:error];
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark LocationDelegate methods

- (void)locationStoppedUpdatingFromTimeout
{
    //[[ThreadedUpdates shared] loadPlacesPassivelyWithCurrentLocation];
    
    //    [Flurry logEvent:@"FAILED_TO_GET_DESIRED_LOCATION_ACCURACY_APP_LAUNCH"];
    if (!self.currentUser)
        return;
    [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
        
    } onError:^(NSError *error) {
        
    }];
}

- (void)didGetBestLocationOrTimeout
{
    ALog(@"");
    if (!self.currentUser)
        return;
    
    //[[ThreadedUpdates shared] loadPlacesPassivelyWithCurrentLocation];
    //    [Flurry logEvent:@"DID_GET_DESIRED_LOCATION_ACCURACY_APP_LAUNCH"];
    [self.managedObjectContext performBlock:^{
        [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
            
        } onError:^(NSError *error) {
            
        }];
    }];
}

- (void)failedToGetLocation:(NSError *)error
{
    DLog(@"%@", error);
    //    [Flurry logEvent:@"FAILED_TO_GET_ANY_LOCATION_APP_LAUNCH"];
}


#pragma mark - UrbanAirship configuration

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA.
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    ALog(@"Received remote notification: %@", userInfo);
    ALog(@"delegate is %@", [UAPush shared].delegate);
    [[UAPush shared] handleNotification:userInfo applicationState:application.applicationState];
    [[UAPush shared] resetBadge]; // zero badge after push received
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    ALog(@"sourceApplication  is %@ url %@, %@annotation", sourceApplication, url, annotation);
    return [FBSession.activeSession handleOpenURL:url];
}


- (void)resetWindowToInitialView
{
    for (UIView* view in self.window.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIViewController *initialScene = [_initalStoryboard instantiateInitialViewController];
    self.window.rootViewController = initialScene;
    
    InitialViewController *vc = (InitialViewController *)self.window.rootViewController;
    vc.managedObjectContext = self.managedObjectContext;
    self.currentUser = [User currentUser:self.managedObjectContext];
    vc.currentUser = self.currentUser;
}


- (void)fetchNotifications {
    if (self.currentUser) {
        [self.managedObjectContext performBlock:^{
            [RestNotification reload:^(NSArray *notifications) {
                for (RestNotification *restNotification in notifications) {
                    Notification *notification = [Notification notificationWithRestNotification:restNotification inManagedObjectContext:self.managedObjectContext];
                    [self.currentUser addNotificationsObject:notification];
                }
                NSError *error;
                [self.managedObjectContext save:&error];
                
            } onError:^(NSError *error) {
                
            }];
        }];
    }
}


@end
