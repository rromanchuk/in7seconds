//
//  RestMutualFriend.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/31/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestMutualFriend.h"

@implementation RestMutualFriend

+ (NSDictionary *)mapping {
    return @{@"first_name": @"firstName",
                                       @"last_name": @"lastName",
                                       @"photo_url": @"photoUrl",
                                       @"id": @"externalId"};

}

@end
