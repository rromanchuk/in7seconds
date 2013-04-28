//
//  Hookup+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/23/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Hookup+REST.h"
#import "RestMutualFriend.h"
#import "MutualFriend+REST.h"
#import "Image+REST.h"

@implementation Hookup (REST)
+ (Hookup *)hookupWithRestHookup:(RestHookup *)restHookup
          inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Hookup *hookup;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hookup"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", [NSNumber numberWithInt:restHookup.externalId]];
    
    NSError *error = nil;
    NSArray *hookups = [context executeFetchRequest:request error:&error];
    //ALog(@"looking for user with externalId %d got %@ from restUser %@ with context %@", restUser.externalId, users, restUser, context);
    if (hookups && ([hookups count] > 1)) {
        // handle error
        ALog(@"not returning a user");
    } else if (![hookups count]) {
        hookup = [NSEntityDescription insertNewObjectForEntityForName:@"Hookup"
                                             inManagedObjectContext:context];
        
        [hookup setManagedObjectWithIntermediateObject:restHookup];
        
    } else {
        hookup = [hookups lastObject];
        [hookup setManagedObjectWithIntermediateObject:restHookup];
    }
    
    return hookup;

    
}

+ (Hookup *)hookupWithExternalId:(NSNumber *)externalId
          inManagedObjectContext:(NSManagedObjectContext *)context {
    
}


- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestHookup *restHookup = (RestHookup *) intermediateObject;
    self.firstName = restHookup.firstName;
    self.lastName = restHookup.lastName;
    self.email = restHookup.email;
    self.photoUrl = restHookup.photoUrl;
    self.externalId = [NSNumber numberWithInt:restHookup.externalId];
    self.vkUniversityName = restHookup.vkUniversityName;
    self.vkGraduation = restHookup.vkGraduation;
    self.vkFacultyName = restHookup.vkFacultyName;
    
    self.gender = [NSNumber numberWithInteger:restHookup.gender];
    self.country = restHookup.country;
    self.city = restHookup.city;
    self.mutualFriendsNum = [NSNumber numberWithInteger:restHookup.mutualFriendsNum];
    self.mutualGroups = [NSNumber numberWithInteger:restHookup.mutualGroups];
    self.birthday = restHookup.birthday;
    self.vkDomain = restHookup.vkDomain;
    self.groupNames = restHookup.groupNames;
    self.friendNames = restHookup.friendNames;
    self.mutualFriendNames = restHookup.mutualFriendNames;
    self.mutualGroupNames = restHookup.mutualGroupNames;
    
    NSMutableSet *mutualFriends;
    for (RestMutualFriend *restMutaulFriend in restHookup.mutualFriendObjects) {
        MutualFriend *mutualFriend = [MutualFriend mutualFriendWithRestMutualFriend:restMutaulFriend inManagedObjectContext:self.managedObjectContext];
        [mutualFriends addObject:mutualFriend];
    }
    [self addMutualFriends:mutualFriends];
    
    for (RestImage *restImage in restHookup.images) {
        [self addImagesObject:[Image imageWithRestImage:restImage inManagedObjectContext:self.managedObjectContext]];
    }
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *)schoolInfo {
    if (self.vkUniversityName && self.vkGraduation.length > 1) {
        return [NSString stringWithFormat:@"%@, %@", self.vkUniversityName, self.vkGraduation];
    } else if (self.vkUniversityName) {
        return [NSString stringWithFormat:@"%@", self.vkUniversityName];
    }
    return nil;
}

- (NSString *)vkUrl {
    if (self.vkDomain) {
        return [NSString stringWithFormat:@"http://vk.com/%@", self.vkDomain];
    }
    return nil;
}

- (NSString *)russianFullName {
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
