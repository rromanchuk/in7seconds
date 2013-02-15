//
//  ThreadedUpdates.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 9/22/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


@interface ThreadedUpdates : NSObject
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
+ (ThreadedUpdates *)shared;
- (void)fetchNotifications;
- (void)fetchMatches;
@end
