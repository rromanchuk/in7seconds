//
//  MutualFriend.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 9/17/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hookup, Match;

@interface MutualFriend : NSManagedObject

@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) Hookup *hookup;
@property (nonatomic, retain) Match *match;

@end
