//
//  User.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * authenticationToken;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * lookingForGender;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * vkToken;
@property (nonatomic, retain) NSSet *possibleHookups;
@property (nonatomic, retain) NSSet *hookups;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPossibleHookupsObject:(User *)value;
- (void)removePossibleHookupsObject:(User *)value;
- (void)addPossibleHookups:(NSSet *)values;
- (void)removePossibleHookups:(NSSet *)values;

- (void)addHookupsObject:(User *)value;
- (void)removeHookupsObject:(User *)value;
- (void)addHookups:(NSSet *)values;
- (void)removeHookups:(NSSet *)values;

@end
