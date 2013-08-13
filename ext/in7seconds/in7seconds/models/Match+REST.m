//
//  Match+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/23/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Match+REST.h"
#import "MutualFriend+REST.h"
#import "Image+REST.h"
#import "User+REST.h"
#import <MapKit/MapKit.h>
#import "Group+REST.h"

@implementation Match (REST)

+ (Match *)matchWithRestMatch:(RestMatch *)restMatch
       inManagedObjectContext:(NSManagedObjectContext *)context {
    //ALog(@"");
    //ALog(@"match id is %d", restMatch.externalId);
    //ALog(@"restMatch object is %@", restMatch);

    Match *match;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", @(restMatch.externalId)];
    //ALog(@"");

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    //ALog(@"looking for user with externalId %d got %@ from restUser %@ with context %@", restUser.externalId, users, restUser, context);
    if (matches && ([matches count] > 1)) {
        // handle error
        ALog(@"not returning a user");
    } else if (![matches count]) {
        match = [NSEntityDescription insertNewObjectForEntityForName:@"Match"
                                               inManagedObjectContext:context];
        
        [match setManagedObjectWithIntermediateObject:restMatch];
        
    } else {
        match = [matches lastObject];
        [match setManagedObjectWithIntermediateObject:restMatch];
    }
    
    return match;

}

+ (Match *)matchWithExternalId:(NSNumber *)externalId
      inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Match *match;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", externalId];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        // handle error
        match = nil;
    } else if (![matches count]) {
        match = nil;
    } else {
        match = [matches lastObject];
    }
    
    return match;
}

- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestMatch *restMatch = (RestMatch *) intermediateObject;
    ALog(@"");
    self.createdAt = restMatch.createdAt;
    self.firstName = restMatch.firstName;
    self.lastName = restMatch.lastName;
    self.email = restMatch.email;
    self.photoUrl = restMatch.photoUrl;
    self.externalId = @(restMatch.externalId);
    self.vkUniversityName = restMatch.vkUniversityName;
    self.vkGraduation = restMatch.vkGraduation;
    self.vkFacultyName = restMatch.vkFacultyName;
    
    self.gender = @(restMatch.gender);
    self.country = restMatch.country;
    self.city = restMatch.city;
    self.mutualFriendsNum = @(restMatch.mutualFriendsNum);
    self.mutualGroups = @(restMatch.mutualGroups);
    self.birthday = restMatch.birthday;
    self.vkDomain = restMatch.vkDomain;
    self.groupNames = restMatch.groupNames;
    self.friendNames = restMatch.friendNames;
    self.mutualFriendNames = restMatch.mutualFriendNames;
    self.mutualGroupNames = restMatch.mutualGroupNames;
    self.latitude = @(restMatch.latitude);
    self.longitude = @(restMatch.longitude);
    
    for (RestMutualFriend *restMutaulFriend in restMatch.mutualFriendObjects) {
        //ALog(@"adding mutualFriend");
        MutualFriend *mutualFriend = [MutualFriend mutualFriendWithRestMutualFriend:restMutaulFriend inManagedObjectContext:self.managedObjectContext];
        //ALog("mutualFriend managed object %@", mutualFriend);
        [self addMutualFriendsObject:mutualFriend];
    }
    
    
    for (RestImage *restImage in restMatch.images) {
        [self addImagesObject:[Image imageWithRestImage:restImage inManagedObjectContext:self.managedObjectContext]];
    }
    
    for (RestGroup *restGroup in restMatch.groups) {
        [self addGroupsObject:[Group groupWithRestGroup:restGroup inManagedObjectContext:self.managedObjectContext]];
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

- (NSString *)socialUrl {
    if (self.vkDomain) {
        return [NSString stringWithFormat:@"http://vk.com/%@", self.vkDomain];
    } else {
        return [NSString stringWithFormat:@"http://facebook.com/%@", self.fbDomain];
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
    
    return @([difference year]);
}


- (NSString *)getDistanceFrom:(User *)user {
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:[user.latitude doubleValue] longitude:[user.longitude doubleValue]];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    int distance = [@([targetLocation distanceFromLocation:currentLocation]) integerValue];
    //ALog(@"user is %d meters away target %@ current %@", distance, targetLocation, currentLocation);
    NSString *measurement;
    if (distance > 1000) {
        distance = distance / 1000;
        measurement = NSLocalizedString(@"км", nil);
    } else {
        measurement = NSLocalizedString(@"м", nil);
    }
    
    return [NSString stringWithFormat:@"%d%@", distance, measurement];
}

@end


