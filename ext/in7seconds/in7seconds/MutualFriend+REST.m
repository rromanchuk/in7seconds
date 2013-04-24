//
//  MutualFriend+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/23/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MutualFriend+REST.h"

@implementation MutualFriend (REST)
+ (MutualFriend *)mutualFriendWithRestMutualFriend:(RestMutualFriend *)restMutualFriend
                            inManagedObjectContext:(NSManagedObjectContext *)context {
    MutualFriend *mutualFriend;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MutualFriend"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", [NSNumber numberWithInt:restMutualFriend.externalId]];
    
    NSError *error = nil;
    NSArray *mutualFriends = [context executeFetchRequest:request error:&error];
    //ALog(@"looking for user with externalId %d got %@ from restUser %@ with context %@", restUser.externalId, users, restUser, context);
    if (mutualFriends && ([mutualFriends count] > 1)) {
        // handle error
        ALog(@"not returning a user");
    } else if (![mutualFriends count]) {
        mutualFriend = [NSEntityDescription insertNewObjectForEntityForName:@"MutualFriend"
                                               inManagedObjectContext:context];
        
        [mutualFriend setManagedObjectWithIntermediateObject:restMutualFriend];
        
    } else {
        mutualFriend = [mutualFriends lastObject];
        [mutualFriend setManagedObjectWithIntermediateObject:restMutualFriend];
    }
    
    return mutualFriend;
}



+ (MutualFriend *)hookupWithExternalId:(NSNumber *)externalId
          inManagedObjectContext:(NSManagedObjectContext *)context {
    return nil;
}


- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestMutualFriend *restMutualFriend = (RestMutualFriend *) intermediateObject;
    self.firstName = restMutualFriend.firstName;
    self.lastName = restMutualFriend.lastName;
    self.photoUrl = restMutualFriend.photoUrl;
    self.externalId = [NSNumber numberWithInteger:restMutualFriend.externalId];
}
@end
