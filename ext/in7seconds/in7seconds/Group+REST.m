//
//  Group+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Group+REST.h"

@implementation Group (REST)
+ (Group *)groupWithRestGroup:(RestGroup *)restGroup
       inManagedObjectContext:(NSManagedObjectContext *)context {
    Group *group;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", @(restGroup.externalId)];
    
    NSError *error = nil;
    NSArray *groups = [context executeFetchRequest:request error:&error];
    //ALog(@"looking for user with externalId %d got %@ from restUser %@ with context %@", restUser.externalId, users, restUser, context);
    if (groups && ([groups count] > 1)) {
        // handle error
    } else if (![groups count]) {
        group = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
                                              inManagedObjectContext:context];
        
        [group setManagedObjectWithIntermediateObject:restGroup];
        
    } else {
        group = [groups lastObject];
        [group setManagedObjectWithIntermediateObject:restGroup];
    }
    return group;

}

- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestGroup *restGroup = (RestGroup *) intermediateObject;
    
    self.externalId = @(restGroup.externalId);
    self.photo = restGroup.photo;
    self.name = restGroup.name;
    self.provider = restGroup.provider;
}
@end
