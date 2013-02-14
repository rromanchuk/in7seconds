//
//  BaseUIView.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "BaseUIView.h"

@implementation BaseUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    self.backgroundColor = [UIColor backgroundColor];
}


@end
