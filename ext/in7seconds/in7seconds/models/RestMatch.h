//
//  RestMatch.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/23/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@interface RestMatch : RestObject
@property NSInteger gender;
@property NSInteger lookingForGender;
@property NSInteger mutualGroups;
@property NSInteger mutualFriendsNum;
@property float latitude;
@property float longitude;
// Attributes
@property (atomic, strong) NSString *firstName;
@property (atomic, strong) NSString *lastName;
@property (atomic, strong) NSString *email;
@property (atomic, strong) NSString *photoUrl;
@property (atomic, strong) NSString *city;
@property (atomic, strong) NSString *country;
@property (atomic, strong) NSDate *birthday;
@property (atomic, strong) NSDate *createdAt;

@property (atomic, strong) NSString *vkUniversityName;
@property (atomic, strong) NSString *vkGraduation;
@property (atomic, strong) NSString *vkFacultyName;
@property (atomic, strong) NSString *vkDomain;


@property (atomic, strong) NSString *groupNames;
@property (atomic, strong) NSString *friendNames;
@property (atomic, strong) NSString *mutualFriendNames;
@property (atomic, strong) NSString *mutualGroupNames;

@property (atomic, strong) NSSet *mutualFriendObjects;
@property (atomic, strong) NSSet *images;

+ (NSDictionary *)mapping;
+ (void)load:(void (^)(NSMutableArray *matches))onLoad
     onError:(void (^)(NSError *error))onError;

@end
