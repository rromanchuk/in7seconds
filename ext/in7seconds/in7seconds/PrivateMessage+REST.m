//
//  Message+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "PrivateMessage+REST.h"

@implementation PrivateMessage (REST)


+ (PrivateMessage *)privateMessageWithRestMessage:(RestMessage *)restMessage
             inManagedObjectContext:(NSManagedObjectContext *)context {
    
    PrivateMessage *message;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PrivateMessage"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", [NSNumber numberWithInt:restMessage.externalId]];
    
    NSError *error = nil;
    NSArray *messages = [context executeFetchRequest:request error:&error];
    
    if (!messages || ([messages count] > 1)) {
        // handle error
    } else if (![messages count]) {
        message = [NSEntityDescription insertNewObjectForEntityForName:@"PrivateMessage"
                                             inManagedObjectContext:context];
        
        [message setManagedObjectWithIntermediateObject:restMessage];
        
    } else {
        message = [messages lastObject];
        [message setManagedObjectWithIntermediateObject:restMessage];
    }
    return message;

}

- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestMessage *restMessage = (RestMessage *) intermediateObject;
    self.message = restMessage.message;
    self.createdAt = restMessage.createdAt;
    self.fromUser = [User userWithRestUser:restMessage.fromUser inManagedObjectContext:self.managedObjectContext];
    self.toUser = [User userWithRestUser:restMessage.toUser inManagedObjectContext:self.managedObjectContext];
}
@end