//
//  User+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "User+REST.h"

@implementation User (REST)
+ (User *)userWithRestUser:(RestUser *)restUser
    inManagedObjectContext:(NSManagedObjectContext *)context {
    
    User *user;
    ALog(@"restUser coming in from coredata is %@", restUser);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", [NSNumber numberWithInt:restUser.externalId]];
    
    NSError *error = nil;
    NSArray *users = [context executeFetchRequest:request error:&error];
    ALog(@"returning coredata users %@", users);

    if (!users || ([users count] > 1)) {
        // handle error
    } else if (![users count]) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:context];
        
        ALog(@"coredata user is %@", user);
        [user setManagedObjectWithIntermediateObject:restUser];
        
    } else {
        user = [users lastObject];
        [user setManagedObjectWithIntermediateObject:restUser];
    }
    ALog(@"returning coredata user %@", user);
    return user;
}


+ (User *)userWithExternalId:(NSNumber *)externalId
      inManagedObjectContext:(NSManagedObjectContext *)context {
    
    User *user;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", externalId];
    
    NSError *error = nil;
    NSArray *users = [context executeFetchRequest:request error:&error];
    if (!users || ([users count] > 1)) {
        // handle error
        user = nil;
    } else if (![users count]) {
        user = nil;
    } else {
        user = [users lastObject];
    }
    
    return user;
}

+ (User *)currentUser:(NSManagedObjectContext *)context {
    NSNumber *currentId =  [NSNumber numberWithInteger:[[RestUser currentUserId] integerValue]];
    ALog(@"Current userId is %@", currentId);
    
    if ([RestUser currentUserId]) {
        User *user = [User userWithExternalId:currentId inManagedObjectContext:context];
        ALog("got user %@", user);
        return user;
    }
    
    return nil;
}

+ (User *)findOrCreateUserWithRestUser:(RestUser *)user
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *new_user = [User userWithRestUser:user inManagedObjectContext:context];
    NSError *error = nil;
    if (![context save:&error]) {
        ALog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return new_user;
}


- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestUser *restUser = (RestUser *) intermediateObject;
    self.firstName = restUser.firstName;
    self.lastName = restUser.lastName;
    //self.email = restUser.email;
    self.photoUrl = restUser.photoUrl;
    self.externalId = [NSNumber numberWithInt:restUser.externalId];
    self.authenticationToken = restUser.authenticationToken;
    self.vkToken = restUser.vkToken;
    //self.fbToken = restUser.fbToken;
    self.location = restUser.location;
    self.gender = [NSNumber numberWithInteger:restUser.gender];
    self.birthday = restUser.birthday;
    self.updatedAt = restUser.updatedAt;
    
    for (RestUser *_restUser in restUser.possibleHookups) {
        User *user = [User userWithRestUser:_restUser inManagedObjectContext:self.managedObjectContext];
        [self addPossibleHookupsObject:user];
    }
    // Add following if they exist
//    if ([restUser.following count] > 0) {
//        [self removeFollowing:self.following];
//        NSMutableSet *following = [[NSMutableSet alloc] init];
//        for (RestUser *friend_restUser in restUser.following) {
//            User *user = [User userWithRestUser:friend_restUser inManagedObjectContext:self.managedObjectContext];
//            if (user) {
//                [following addObject:user];
//            }
//        }
//        [self addFollowing:following];
//    }
    
//    // Add followers if they exist
//    if ([restUser.followers count] > 0) {
//        [self removeFollowers:self.followers];
//        NSMutableSet *followers = [[NSMutableSet alloc] init];
//        for (RestUser *friend_restUser in restUser.followers) {
//            User *user_ = [User userWithRestUser:friend_restUser inManagedObjectContext:self.managedObjectContext];
//            if (user_) {
//                [followers addObject:user_];
//            }
//        }
//        [self addFollowers:followers];
//    }
//    
    
}

- (NSNumber *)yearsOld {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:self.birthday];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *difference = [calendar components:NSYearCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [NSNumber numberWithInteger:[difference year]];
}

@end
