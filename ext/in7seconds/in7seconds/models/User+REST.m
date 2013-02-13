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
    
    if (!users || ([users count] > 1)) {
        // handle error
    } else if (![users count]) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:context];
        
        [user setManagedObjectWithIntermediateObject:restUser];
        
    } else {
        user = [users lastObject];
        [user setManagedObjectWithIntermediateObject:restUser];
    }
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


+ (User *)findOrCreateUserWithRestUser:(RestUser *)user
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *new_user =[User userWithRestUser:user inManagedObjectContext:context];
    NSError *error = nil;
    if (![context save:&error]) {
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return new_user;
}


- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestUser *restUser = (RestUser *) intermediateObject;
//    self.firstname = restUser.firstName;
//    self.lastname = restUser.lastName;
//    self.checkinsCount = [NSNumber numberWithInt:restUser.checkinsCount];
//    self.fullName = restUser.fullName;
//    self.email = restUser.email;
//    self.remoteProfilePhotoUrl = restUser.remoteProfilePhotoUrl;
//    self.externalId = [NSNumber numberWithInt:restUser.externalId];
//    self.authentication_token = restUser.authenticationToken;
//    self.fbToken = restUser.fbToken;
//    self.vkontakteToken = restUser.vkToken;
//    self.location = restUser.location;
//    self.gender = [NSNumber numberWithInteger:restUser.gender];
//    self.birthday = restUser.birthday;
//    self.registrationStatus = [NSNumber numberWithInteger:restUser.registrationStatus];
//    self.isFollowed = [NSNumber numberWithInteger:restUser.isFollowed];
//    self.modifiedDate = restUser.modifiedDate;
//    
//    // Add following if they exist
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
//    
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

@end
