//
//  UIColor+Defaults.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "UIColor+Defaults.h"

@implementation UIColor (Defaults)
+ (UIColor *)backgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)darkBackgroundColor {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"settings_bg"]];
}


@end
