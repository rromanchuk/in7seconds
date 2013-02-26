//
//  RestHookup.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@interface RestHookup : RestObject

// Attributes
@property (atomic, strong) NSString *firstName;
@property (atomic, strong) NSString *lastName;
@property (atomic, strong) NSString *email;
@property (atomic, strong) NSString *photoUrl;
@property (atomic, strong) NSString *location;
@property (atomic, strong) NSDate *birthday;

@end
