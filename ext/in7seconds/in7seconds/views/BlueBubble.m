//
//  BlueBubble.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/10/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "BlueBubble.h"

@implementation BlueBubble

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
        CGSize size = self.frame.size;
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.imgView.image = [[UIImage imageNamed:@"blue_bubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 7, 10, 14)];
        [self addSubview:self.imgView];
        self.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width - 25 , size.height)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.numberOfLines = 0;
        [self addSubview:self.label];
        //self.label.backgroundColor = [UIColor yellowColor];
    }
    return self;
}


- (void)setMessage:(NSString *)message {
    self.label.text = message;
    CGSize size = [message sizeWithFont:self.label.font constrainedToSize:CGSizeMake(self.label.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    ALog("expected size %f", size.height);
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height + 20)];
    [self.imgView setFrame:CGRectMake(0, 0, self.frame.size.width, size.height + 20)];
    
    [self.label setFrame:CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y, self.label.frame.size.width, size.height + 20)];
    
}

- (void)awakeFromNib {
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 1)];
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



@end
