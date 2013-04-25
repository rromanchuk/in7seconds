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
    Thread *thread;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Thread"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", [NSNumber numberWithInt:restThread.externalId]];
    
    NSError *error = nil;
    NSArray *threads = [context executeFetchRequest:request error:&error];
    //ALog(@"looking for user with externalId %d got %@ from restUser %@ with context %@", restUser.externalId, users, restUser, context);
    if (threads && ([threads count] > 1)) {
        // handle error
        ALog(@"not returning a user");
    } else if (![threads count]) {
        thread = [NSEntityDescription insertNewObjectForEntityForName:@"Thread"
                                                     inManagedObjectContext:context];
        
        [thread setManagedObjectWithIntermediateObject:restThread];
        
    } else {
        thread = [threads lastObject];
        [thread setManagedObjectWithIntermediateObject:restThread];
    }
    
    return thread;
}

- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestThread *restThread = (RestThread *) intermediateObject;
    self.withMatch = [Match matchWithRestMatch:restThread.withMatch inManagedObjectContext:self.managedObjectContext];
    self.user = [User userWithRestUser:restThread.user inManagedObjectContext:self.managedObjectContext];
    for (RestMessage *restMessage in restThread.messages) {
        [self addMessagesObject:[PrivateMessage privateMessageWithRestMessage:restMessage inManagedObjectContext:self.managedObjectContext]];
    }
    
}
@end
