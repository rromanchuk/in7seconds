//
//  RestGroup.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestGroup.h"

@implementation RestGroup

+ (NSDictionary *)mapping {
    return @{@"id": @"externalId",
             @"photo_url": @"photo",
             @"provider": @"provider",
             @"name": @"name"
             };
    
}

@end
