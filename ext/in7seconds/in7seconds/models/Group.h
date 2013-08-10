//
//  Group.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hookup, Match;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * provider;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) Match *match;
@property (nonatomic, retain) Hookup *hookup;

@end
