//
//  RestImage.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/28/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"
@interface RestImage : RestObject
@property (strong, atomic) NSString *photoUrl;
+ (NSDictionary *)mapping;
@end
