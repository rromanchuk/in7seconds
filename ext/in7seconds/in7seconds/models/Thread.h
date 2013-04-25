//
//  Thread.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/25/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Match, PrivateMessage, User;

@interface Thread : NSManagedObject

@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Match *withMatch;
@end

@interface Thread (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(PrivateMessage *)value;
- (void)removeMessagesObject:(PrivateMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
