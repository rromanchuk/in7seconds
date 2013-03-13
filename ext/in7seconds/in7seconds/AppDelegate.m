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
#import "Config.h"
#import "Facebook.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize privateWriterContext = __privateWriterContext;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Flurry startSession:@"7RBHDYVR2RPTKP7NT4XN"];
    [TestFlight takeOff:@"8b9f2759-9e2b-48d9-873b-d3af3677d35b"];
    [Crashlytics startWithAPIKey:@"cbbca2d940f872c4617ddb67cf20ec9844d036ea"];
    
    
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    NSMutableDictionary *airshipConfigOptions = [[NSMutableDictionary alloc] init];
    
    [airshipConfigOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    [airshipConfigOptions setValue:[Config sharedConfig].airshipKeyDev forKey:@"DEVELOPMENT_APP_KEY"];
    [airshipConfigOptions setValue:[Config sharedConfig].airshipSecretDev forKey:@"DEVELOPMENT_APP_SECRET"];
    [airshipConfigOptions setValue:[Config sharedConfig].airshipKeyProd  forKey:@"PRODUCTION_APP_KEY"];
    [airshipConfigOptions setValue:[Config sharedConfig].airshipSecretProd  forKey:@"PRODUCTION_APP_SECRET"];
    
#ifdef DEBUG
    [airshipConfigOptions setValue:@"NO" forKey:@"APP_STORE_OR_AD_HOC_BUILD"];
#else
    [airshipConfigOptions setValue:@"YES" forKey:@"APP_STORE_OR_AD_HOC_BUILD"];
#endif
    
    [takeOffOptions setValue:airshipConfigOptions forKey:UAirshipTakeOffOptionsAirshipConfigKey];
    
    [UAirship takeOff:takeOffOptions];
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
    InitialViewController *vc = (InitialViewController *)self.window.rootViewController;
    vc.managedObjectContext = self.managedObjectContext;
    self.currentUser = [User currentUser:self.managedObjectContext];
    vc.currentUser = self.currentUser;
    [self theme];
    
    [FBSettings publishInstall:@"138127329695553"];
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.delegate applicationWillWillStart];
    
    [Location sharedLocation].delegate = self;
    [[Location sharedLocation] updateUntilDesiredOrTimeout:15.0];
    
    if (self.currentUser) {
        [RestUser reload:^(RestUser *restUser) {
            self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
        } onError:^(NSError *error) {
            
        }];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [UAirship land];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)theme {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigation-bar"] forBarMetrics:UIBarMetricsDefault];
    
    navigationBarAppearance.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:20.0], UITextAttributeFont,
                                                   RGBACOLOR(159, 169, 172, 1.0), UITextAttributeTextColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset, nil];

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
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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
    [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
        
    } onError:^(NSError *error) {
        
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


@end
