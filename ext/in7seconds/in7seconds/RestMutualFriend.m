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
    return [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"firstName", @"first_name",
                                       @"lastName", @"last_name",
                                       @"photoUrl", @"photo_url",
                                       nil];

}

@end
