//
//  UserImageContainer.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 6/29/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "UserImageContainer.h"

@implementation UserImageContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    UITouch *aTouch = [touches anyObject];
//    // Only move the placard view if the touch was in the placard view.
//		CGPoint location = [aTouch locationInView:self];
//        CGPoint previousLocation = [aTouch previousLocationInView:self];
//        self.frame = CGRectOffset(self.frame, location.x-previousLocation.x, location.y-    previousLocation.y);
//        
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    ALog(@"touch began");
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    ALog(@"touches ended");
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
