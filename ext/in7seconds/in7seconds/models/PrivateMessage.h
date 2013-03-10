//
//  PrivateMessage.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/9/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface PrivateMessage : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) User *toUser;
@property (nonatomic, retain) User *fromUser;

@end
