//
//  Thread+REST.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/24/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Thread.h"
#import "RestThread.h"

@interface Thread (REST)
+ (Thread *)threadWithRestThread:(RestThread *)restThread
          inManagedObjectContext:(NSManagedObjectContext *)context;
@end
