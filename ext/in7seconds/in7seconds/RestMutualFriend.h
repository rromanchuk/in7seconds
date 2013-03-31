//
//  RestMutualFriend.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/31/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@interface RestMutualFriend : RestObject
@property NSInteger gender;
@property NSInteger lookingForGender;
@property NSInteger mutualGroups;
@property NSInteger mutualFriendsNum;

// Identifiers
@property (atomic, strong) NSString *authenticationToken;
@property (atomic, strong) NSString *fbToken;
@property (atomic, strong) NSString *vkToken;
@property (atomic, strong) NSString *vkUniversityName;
@property (atomic, strong) NSString *vkGraduation;
@property (atomic, strong) NSString *vkFacultyName;



// Attributes
@property (atomic, strong) NSString *firstName;
@property (atomic, strong) NSString *lastName;
@property (atomic, strong) NSString *groupNames;
@property (atomic, strong) NSString *friendNames;
@property (atomic, strong) NSString *mutualFriendNames;
@property (atomic, strong) NSString *mutualGroupNames;

@property (atomic, strong) NSString *email;
@property (atomic, strong) NSString *photoUrl;
@property (atomic, strong) NSString *city;
@property (atomic, strong) NSString *country;
@property (atomic, strong) NSString *vkDomain;
@property (atomic, strong) NSDate *birthday;
@property (atomic, strong) NSDate *updatedAt;
@property (atomic, strong) NSDate *createdAt;
@property (atomic, strong) NSSet *possibleHookups;
@property (atomic, strong) NSSet *hookups;
@property (atomic, strong) NSSet *mutualFriends;


+ (NSDictionary *)mapping;

@end
