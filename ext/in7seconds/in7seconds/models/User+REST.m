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

+ (User *)currentUser:(NSManagedObjectContext *)context {
    NSNumber *currentId =  [NSNumber numberWithInteger:[[RestUser currentUserId] integerValue]];
    
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
    self.email = restUser.email;
    self.photoUrl = restUser.photoUrl;
    self.externalId = [NSNumber numberWithInt:restUser.externalId];
    self.authenticationToken = restUser.authenticationToken;
    self.vkToken = restUser.vkToken;
    //self.fbToken = restUser.fbToken;
    self.location = restUser.location;
    self.gender = [NSNumber numberWithInteger:restUser.gender];
    self.country = restUser.country;
    self.city = restUser.city;
    self.mutualFriends = [NSNumber numberWithInteger:restUser.mutualFriends];
    self.mutualGroups = [NSNumber numberWithInteger:restUser.mutualGroups];
    self.birthday = restUser.birthday;
    self.updatedAt = restUser.updatedAt;
    self.vkDomain = restUser.vkDomain;
    
    [self removePossibleHookups:self.possibleHookups];
    for (RestUser *_restUser in restUser.possibleHookups) {
        User *user = [User userWithRestUser:_restUser inManagedObjectContext:self.managedObjectContext];
        [self addPossibleHookupsObject:user];
    }
    
    [self removeHookups:self.hookups];
    for (RestUser *_restUser in restUser.hookups) {
        User *user = [User userWithRestUser:_restUser inManagedObjectContext:self.managedObjectContext];
        [self addHookupsObject:user];
    }
      
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.lastName, self.firstName];
}

- (NSString *)fullLocation {
    if (self.city.length && self.country.length) {
        return [NSString stringWithFormat:@"%@, %@", self.city, self.country];
    } else if (self.city.length) {
        return self.city;
    } else if (self.country.length) {
        return self.country;
    } else {
        return @"";
    }
    
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
