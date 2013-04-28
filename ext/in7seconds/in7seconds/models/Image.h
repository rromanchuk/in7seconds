//
//  Image.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/28/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hookup, Match, User;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Match *match;
@property (nonatomic, retain) Hookup *hookup;

@end
