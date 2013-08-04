//
//  Match.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/4/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, MutualFriend, Notification, Thread, User;

@interface Match : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * friendNames;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * groupNames;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * mutualFriendNames;
@property (nonatomic, retain) NSNumber * mutualFriendsNum;
@property (nonatomic, retain) NSString * mutualGroupNames;
@property (nonatomic, retain) NSNumber * mutualGroups;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSString * vkDomain;
@property (nonatomic, retain) NSString * vkFacultyName;
@property (nonatomic, retain) NSString * vkGraduation;
@property (nonatomic, retain) NSString * vkToken;
@property (nonatomic, retain) NSString * vkUniversityName;
@property (nonatomic, retain) NSString * fbDomain;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *mutualFriends;
@property (nonatomic, retain) NSSet *sentNotifcation;
@property (nonatomic, retain) Thread *thread;
@property (nonatomic, retain) User *user;
@end

@interface Match (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addMutualFriendsObject:(MutualFriend *)value;
- (void)removeMutualFriendsObject:(MutualFriend *)value;
- (void)addMutualFriends:(NSSet *)values;
- (void)removeMutualFriends:(NSSet *)values;

- (void)addSentNotifcationObject:(Notification *)value;
- (void)removeSentNotifcationObject:(Notification *)value;
- (void)addSentNotifcation:(NSSet *)values;
- (void)removeSentNotifcation:(NSSet *)values;

@end
