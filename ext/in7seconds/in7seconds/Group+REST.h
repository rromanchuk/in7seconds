//
//  Group+REST.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Group.h"
#import "RestGroup.h"
@interface Group (REST)
+ (Group *)groupWithRestGroup:(RestGroup *)restGroup
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
