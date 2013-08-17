//
//  User.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/17/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hookup, Image, Match, Notification, Thread;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * authenticationToken;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * emailOptIn;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * fbDomain;
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
@property (nonatomic, retain) NSNumber * pushOptIn;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * vkDomain;
@property (nonatomic, retain) NSString * vkFacultyName;
@property (nonatomic, retain) NSString * vkGraduation;
@property (nonatomic, retain) NSString * vkUniversityName;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *hookups;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *matches;
@property (nonatomic, retain) NSSet *notifications;
@property (nonatomic, retain) NSSet *threads;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHookupsObject:(Hookup *)value;
- (void)removeHookupsObject:(Hookup *)value;
- (void)addHookups:(NSSet *)values;
- (void)removeHookups:(NSSet *)values;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addMatchesObject:(Match *)value;
- (void)removeMatchesObject:(Match *)value;
- (void)addMatches:(NSSet *)values;
- (void)removeMatches:(NSSet *)values;

- (void)addNotificationsObject:(Notification *)value;
- (void)removeNotificationsObject:(Notification *)value;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

- (void)addThreadsObject:(Thread *)value;
- (void)removeThreadsObject:(Thread *)value;
- (void)addThreads:(NSSet *)values;
- (void)removeThreads:(NSSet *)values;

@end
