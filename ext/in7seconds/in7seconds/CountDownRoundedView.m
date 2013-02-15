//
//  CountDownRoundedView.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 9/17/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "CountDownRoundedView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CountDownRoundedView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = NO;
    self.layer.cornerRadius = 25.0;
    self.layer.masksToBounds = YES;
    
}

@end
