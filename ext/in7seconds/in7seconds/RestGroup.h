//
//  RestGroup.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@interface RestGroup : RestObject
@property (strong, atomic) NSString *name;
@property (strong, atomic) NSString *photo;
@property (strong, atomic) NSString *provider;

+ (NSDictionary *)mapping;

@end
