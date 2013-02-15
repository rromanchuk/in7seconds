//
//  CircleView.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 9/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CircleView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        self.layer.cornerRadius = 8.0;
    }
    return self;
}

@end
