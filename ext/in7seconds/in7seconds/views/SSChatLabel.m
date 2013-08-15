//
//  SSChatLabel.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/15/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "SSChatLabel.h"

@implementation SSChatLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0,8,0,5};
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
