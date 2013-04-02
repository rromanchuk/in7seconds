//
//  User.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/2/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * authenticationToken;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * friendNames;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * groupNames;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * lookingForGender;
@property (nonatomic, retain) NSString * mutualFriendNames;
@property (nonatomic, retain) NSNumber * mutualFriendsNum;
@property (nonatomic, retain) NSString * mutualGroupNames;
@property (nonatomic, retain) NSNumber * mutualGroups;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * vkDomain;
@property (nonatomic, retain) NSString * vkFacultyName;
@property (nonatomic, retain) NSString * vkGraduation;
@property (nonatomic, retain) NSString * vkToken;
@property (nonatomic, retain) NSString * vkUniversityName;
@property (nonatomic, retain) NSSet *hookups;
@property (nonatomic, retain) NSSet *mutalFriendObjects;
@property (nonatomic, retain) NSSet *possibleHookups;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHookupsObject:(User *)value;
- (void)removeHookupsObject:(User *)value;
- (void)addHookups:(NSSet *)values;
- (void)removeHookups:(NSSet *)values;

- (void)addMutalFriendObjectsObject:(User *)value;
- (void)removeMutalFriendObjectsObject:(User *)value;
- (void)addMutalFriendObjects:(NSSet *)values;
- (void)removeMutalFriendObjects:(NSSet *)values;

- (void)addPossibleHookupsObject:(User *)value;
- (void)removePossibleHookupsObject:(User *)value;
- (void)addPossibleHookups:(NSSet *)values;
- (void)removePossibleHookups:(NSSet *)values;

@end
