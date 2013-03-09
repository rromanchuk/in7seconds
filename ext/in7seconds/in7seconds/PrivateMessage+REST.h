//
//  Message+REST.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"
#import "RestMessage.h"
#import "PrivateMessage.h"

@interface PrivateMessage (REST)
- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject;

+ (PrivateMessage *)privateMessageWithRestMessage:(RestMessage *)restMessage
    inManagedObjectContext:(NSManagedObjectContext *)context;

@end
