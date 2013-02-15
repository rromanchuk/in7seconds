//
//  PrivateMessage.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 9/26/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Match, User;

@interface PrivateMessage : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * isFromSelf;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Match *withMatch;

@end
