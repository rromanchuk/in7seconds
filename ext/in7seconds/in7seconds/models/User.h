//
//  User.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/16/13.
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
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * vkToken;
@property (nonatomic, retain) NSNumber * lookingForGender;
@property (nonatomic, retain) NSSet *possibleHookups;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPossibleHookupsObject:(User *)value;
- (void)removePossibleHookupsObject:(User *)value;
- (void)addPossibleHookups:(NSSet *)values;
- (void)removePossibleHookups:(NSSet *)values;

@end
