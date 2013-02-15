//
//  CountDownView.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 9/17/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "CountDownView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CountDownView


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
//        self.layer.cornerRadius = 8.0;
//        self.layer.borderColor = RGBCOLOR(233, 233, 233).CGColor;
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 15.0;
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.15f;
    self.layer.cornerRadius = 25.0;


    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius] CGPath]];
}

@end
