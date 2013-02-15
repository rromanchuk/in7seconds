//
//  RestMutualFriend.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/31/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@interface RestMutualFriend : RestObject

// Attributes
@property (atomic, strong) NSString *firstName;
@property (atomic, strong) NSString *lastName;
@property (atomic, strong) NSString *photoUrl;


+ (NSDictionary *)mapping;

@end
