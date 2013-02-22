//
//  NSNull+NullAddition.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/22/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "NSNull+NullAddition.h"

@implementation NSNull (NullAddition)
+ (id)nullWhenNil:(id)obj {
    
    return (obj ? obj : [self null]);
    
}
@end
