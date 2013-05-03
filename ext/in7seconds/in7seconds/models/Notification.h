//
//  Notification.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 5/3/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Match, User;

@interface Notification : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * notificationType;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Match *sender;

@end
