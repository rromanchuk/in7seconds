//
//  RestImage.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/28/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestImage.h"

@implementation RestImage
+ (NSDictionary *)mapping {
    return @{@"id": @"externalId",
             @"photo_url": @"photoUrl"
             };
    
}
@end
