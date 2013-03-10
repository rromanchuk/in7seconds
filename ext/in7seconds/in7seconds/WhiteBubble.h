//
//  WhiteBubble.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/9/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


@interface WhiteBubble : UIView
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *label;
- (void)setMessage:(NSString *)message;
@end
