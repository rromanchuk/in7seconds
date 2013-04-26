//
//  Thread+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/24/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Thread+REST.h"
#import "Match+REST.h"
#import "User+REST.h"
#import "PrivateMessage+REST.h"
#import "RestMessage.h"
@implementation Thread (REST)

+ (Thread *)threadWithRestThread:(RestThread *)restThread
                            inManagedObjectContext:(NSManagedObjectContext *)context {
    ALog(@"in thread with rest thread")
    ALog(@"thread id is %d", restThread.externalId);
    Thread *thread;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Thread"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", [NSNumber numberWithInt:restThread.externalId]];
    
    NSError *error = nil;
    NSArray *threads = [context executeFetchRequest:request error:&error];
    //ALog(@"looking for user with externalId %d got %@ from restUser %@ with context %@", restUser.externalId, users, restUser, context);
    if (threads && ([threads count] > 1)) {
        // handle error
    } else if (![threads count]) {
        thread = [NSEntityDescription insertNewObjectForEntityForName:@"Thread"
                                                     inManagedObjectContext:context];
        
        [thread setManagedObjectWithIntermediateObject:restThread];
        
    } else {
        thread = [threads lastObject];
        [thread setManagedObjectWithIntermediateObject:restThread];
    }
    ALog(@"returning thread");
    return thread;
}

- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestThread *restThread = (RestThread *) intermediateObject;
    ALog(@"updating thread thread");

    self.externalId = [NSNumber numberWithInteger:restThread.externalId];
    ALog(@"updating external id");
    self.withMatch = [Match matchWithRestMatch:restThread.withMatch inManagedObjectContext:self.managedObjectContext];
    ALog(@"updating with match");

    self.user = [User userWithRestUser:restThread.user inManagedObjectContext:self.managedObjectContext];
    ALog(@"updating with user");

    for (RestMessage *restMessage in restThread.messages) {
        [self addMessagesObject:[PrivateMessage privateMessageWithRestMessage:restMessage inManagedObjectContext:self.managedObjectContext]];
        ALog(@"adding message");

    }
    
}
@end