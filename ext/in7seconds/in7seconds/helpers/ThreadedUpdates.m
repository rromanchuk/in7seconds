//
//  ThreadedUpdates.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 9/22/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ThreadedUpdates.h"
#import "User+REST.h"
#import "Notification+REST.h"
#import "Match+REST.h"
#import "PrivateMessage+REST.h"
#import "RestMessage.h"
@interface ThreadedUpdates () {
    BOOL _matchesRunning;
    BOOL _notificationsRunning;
}

@end


@implementation ThreadedUpdates
+ (ThreadedUpdates *)shared
{
    static dispatch_once_t pred;
    static ThreadedUpdates *sharedThreadedUpdates;
    
    dispatch_once(&pred, ^{
        sharedThreadedUpdates = [[ThreadedUpdates alloc] init];
    });
    
    return sharedThreadedUpdates;
}

- (void)fetchNotifications {
    NSManagedObjectContext *loadNotificationsContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    loadNotificationsContext.parentContext = self.managedObjectContext;
    User *currentUser = [User currentUser:loadNotificationsContext];
    
    [loadNotificationsContext performBlock:^{
        [RestNotification reload:^(NSArray *notifications) {
            for (RestNotification *restNotification in notifications) {
                Notification *notification = [Notification notificationWithRestNotification:restNotification inManagedObjectContext:loadNotificationsContext];
                if (notification)
                    [currentUser addNotificationsObject:notification];
            }
            [loadNotificationsContext save:nil];
            
            [self.managedObjectContext performBlock:^{
                [self.managedObjectContext save:nil];
            }];
            
        } onError:^(NSError *error) {
            
        }];
    }];

}

- (void)fetchMatches {
    
    if (_matchesRunning)
        return;
    
    _matchesRunning = YES;
    NSManagedObjectContext *loadMatchesContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    loadMatchesContext.parentContext = self.managedObjectContext;
    User *user = [User currentUser:loadMatchesContext];
    if (!user)
        return;
    
    
    [loadMatchesContext performBlock:^{
        [RestMatch load:^(NSMutableArray *matches) {
            for (RestMatch *restMatch in matches) {
                Match *match = [Match matchWithRestMatch:restMatch inManagedObjectContext:loadMatchesContext];
                if (match)
                    [user addMatchesObject:match];
            }
            
            [loadMatchesContext save:nil];
            [self.managedObjectContext performBlock:^{
                [self.managedObjectContext save:nil];
                _matchesRunning = NO;
            }];
            
            
        } onError:^(NSError *error) {
            _matchesRunning = NO;
        }];
    }];
    
}



@end
