//
//  Notification+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/26/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Notification+REST.h"
#import "Match+REST.h"
#import "RestNotification.h"
@implementation Notification (REST)
+ (Notification *)notificationWithRestNotification:(RestNotification *)restNotification
                            inManagedObjectContext:(NSManagedObjectContext *)context {
    Notification *notification;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", restNotification.externalId];
    
    NSError *error = nil;
    NSArray *notifications = [context executeFetchRequest:request error:&error];
    //ALog(@"looking for user with externalId %d got %@ from restUser %@ with context %@", restUser.externalId, users, restUser, context);
    if (notifications && ([notifications count] > 1)) {
        // handle error
    } else if (![notifications count]) {
        notification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification"
                                              inManagedObjectContext:context];
        
        [notification setManagedObjectWithIntermediateObject:restNotification];
        
    } else {
        notification = [notifications lastObject];
        [notification setManagedObjectWithIntermediateObject:restNotification];
    }
    return notification;

}

- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestNotification *restNotification = (RestNotification *) intermediateObject;
    
    self.externalId = restNotification.externalId;
    self.message = restNotification.message;
    self.isRead = @(restNotification.isRead);
    self.notificationType = restNotification.notificationType;
    self.createdAt = restNotification.createdAt;
    if (restNotification.sender) {
        self.sender = [Match matchWithRestMatch:restNotification.sender inManagedObjectContext:self.managedObjectContext];
    }
}

+ (void)markAllAsRead:(void (^)(bool status))onLoad
              onError:(void (^)(NSError *error))onError
              forUser:(User *)user
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    request.predicate = [NSPredicate predicateWithFormat:@"user = %@", user];
    NSError *error = nil;
    NSArray *notifications = [context executeFetchRequest:request error:&error];
    for (Notification *notification in notifications) {
        notification.isRead = @(YES);
    }
    
    [RestNotification markAsRead:^(BOOL success) {
        
    } onError:^(NSError *error) {
        
    }];
}

@end
