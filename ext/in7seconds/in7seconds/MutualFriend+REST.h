//
//  MutualFriend+REST.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/23/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MutualFriend.h"
#import "RestMutualFriend.h"
@interface MutualFriend (REST)
+ (MutualFriend *)mutualFriendWithRestMutualFriend:(RestMutualFriend *)restMutualFriend
          inManagedObjectContext:(NSManagedObjectContext *)context;
@end
