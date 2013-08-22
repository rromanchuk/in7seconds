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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.preferredMaxLayoutWidth = 300;
    }
    return self;
}


- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets;
    if (self.tag == 1) {
        insets = UIEdgeInsetsMake(0, 0, 0, 10);
    } else {
       insets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
