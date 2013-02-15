//
//  SwipView.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 6/29/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "SwipeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SwipeView {
    CGPoint _center;
    CGRect _originalRect;
    NSInteger _minRejectX;
    NSInteger _maxAcceptX;
    NSInteger _midpoint;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        _midpoint = (self.frame.size.width / 2.0);
        _minRejectX = _midpoint / 2;
        _maxAcceptX = _midpoint + (_midpoint / 2);
        
    }
    return self;
}

//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    UITouch *aTouch = [touches anyObject];
//    
//    // Only move the placard view if the touch was in the placard view.
//    if (aTouch.view == self.userImageContainer) {
//        ALog(@"touches moved for user image");
//        CGPoint location = [aTouch locationInView:self];
//        CGPoint previousLocation = [aTouch previousLocationInView:self];
//        self.userImageContainer.frame = CGRectOffset(self.userImageContainer.frame, location.x-previousLocation.x, location.y-    previousLocation.y);
//        if (previousLocation.x > location.x) {
//            float rejectAlpha = ((aTouch.view.center.x - 160) / (160 - 0)) * -1.0 ;
//            float acceptAlpha = ((aTouch.view.center.x - _midpoint) / (320 - 160));
//
//            ALog(@"ALPHA IS %f", rejectAlpha);
//            self.rejectImage.alpha = rejectAlpha;
//            self.acceptImage.alpha = acceptAlpha;
//        } else {
//            float rejectAlpha = ((aTouch.view.center.x - 160) / (160 - 0)) * -1.0 ;
//
//            float alpha = ((aTouch.view.center.x - _midpoint) / (320 - 160));
//            self.acceptImage.alpha = alpha;
//            self.rejectImage.alpha = rejectAlpha;
//            ALog(@"ALPHA IS %f", alpha);
//        }
//    }
//}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	// We only support single touches, so anyObject retrieves just that touch from touches.
//	UITouch *touch = [touches anyObject];
//	_center = self.userImageContainer.center;
//	// Only move the placard view if the touch was in the placard view.
//	if ([touch view] == self.userImageContainer) {
//        ALog(@"touches did begin for user image");
//        _originalRect = self.userImageContainer.frame;
//        [self.delegate touchesDidBegin];
//	}
//    
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	UITouch *touch = [touches anyObject];
//	
//	// If the touch was in the placardView, move the placardView to its location.
//	if ([touch view] == self.userImageContainer) {
//		CGPoint location = [touch locationInView:self];
//		self.userImageContainer.center = location;
//		return;
//	}
//}


//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	UITouch *touch = [touches anyObject];
//	
//	// If the touch was in the placardView, bounce it back to the center.
//	if ([touch view] == self.userImageContainer) {
//		/*
//         Disable user interaction so subsequent touches don't interfere with animation until the placard has returned to the center. Interaction is reenabled in animationDidStop:finished:.
//         */
//        CGPoint location = [touch locationInView:self];
//        ALog(@"Location x:%f y%f", location.x, location.y);
//        if (location.x < _minRejectX) {
//            ALog(@"Rejecting user!");
//            [UIView animateWithDuration:0.8 animations:^{
//                self.userImageContainer.frame = CGRectOffset(self.userImageContainer.frame, -200.0, 0);
//            } completion:^(BOOL finished) {
//                [self.delegate didTapUnlike:self];
//                self.rejectImage.alpha = 0;
//                self.acceptImage.alpha = 0;
//                self.userImageContainer.frame = _originalRect;
//            }];
//
//        } else if (location.x > _maxAcceptX) {
//            ALog(@"Accepting user!");
//            [UIView animateWithDuration:0.8 animations:^{
//                self.userImageContainer.frame = CGRectOffset(self.userImageContainer.frame, 200.0, 0);
//            } completion:^(BOOL finished) {
//                [self.delegate didTapLike:self];
//                self.rejectImage.alpha = 0;
//                self.acceptImage.alpha = 0;
//                self.userImageContainer.frame = _originalRect;
//            }];
//
//        } else {
//            [self animatePlacardViewToCenter];
//        }
//                ALog(@"touches did end for user image");
//		[self.delegate touchesDidEnd];
//		//[self animatePlacardViewToCenter];
//		return;
//	}
//}



/*
 First of two possible implementations of animateFirstTouchAtPoint: illustrating different behaviors.
 To choose the second, replace '1' with '0' below.
 */

#define GROW_FACTOR 1.0f
#define SHRINK_FACTOR 1.0f

#if 1

/**
 "Pulse" the placard view by scaling up then down, then move the placard to under the finger.
 */
- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
	/*
	 This illustrates using UIView's built-in animation.  We want, though, to animate the same property (transform) twice -- first to scale up, then to shrink.  You can't animate the same property more than once using the built-in animation -- the last one wins.  So we'll set a delegate action to be invoked after the first animation has finished.  It will complete the sequence.
     
     The touch point is passed in an NSValue object as the context to beginAnimations:. To make sure the object survives until the delegate method, pass the reference as retained.
	 */
	
#define GROW_ANIMATION_DURATION_SECONDS 0.15
	
	NSValue *touchPointValue = [NSValue valueWithCGPoint:touchPoint];
	[UIView beginAnimations:nil context:(__bridge_retained void *)touchPointValue];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(GROW_FACTOR, GROW_FACTOR);
	self.userImageContainer.transform = transform;
	[UIView commitAnimations];
}


- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
#define MOVE_ANIMATION_DURATION_SECONDS 0.15
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS];
	self.userImageContainer.transform = CGAffineTransformMakeScale(SHRINK_FACTOR, SHRINK_FACTOR);
	/*
	 Move the placardView to under the touch.
	 We passed the location wrapped in an NSValue as the context. Get the point from the value, and transfer ownership to ARC to balance the bridge retain in touchesBegan:withEvent:.
	 */
	NSValue *touchPointValue = (__bridge_transfer NSValue *)context;
	self.userImageContainer.center = [touchPointValue CGPointValue];
	[UIView commitAnimations];
}

#else

/*
 Alternate behavior.
 The preceding implementation grows the placard in place then moves it to the new location and shrinks it at the same time.  An alternative is to move the placard for the total duration of the grow and shrink operations; this gives a smoother effect.
 
 */


/**
 Create two separate animations. The first animation is for the grow and partial shrink. The grow animation is performed in a block. The method uses a completion block that itself includes an animation block to perform the shrink. The second animation lasts for the total duration of the grow and shrink animations and contains a block responsible for performing the move.
 */

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
    
#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15
    
    [UIView animateWithDuration:GROW_ANIMATION_DURATION_SECONDS animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(GROW_FACTOR, GROW_FACTOR);
        self.placardView.transform = transform;
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:(NSTimeInterval)SHRINK_ANIMATION_DURATION_SECONDS animations:^{
                             self.placardView.transform = CGAffineTransformMakeScale(SHRINK_FACTOR, SHRINK_FACTOR);
                         }];
                         
                     }];
    
    [UIView animateWithDuration:(NSTimeInterval)GROW_ANIMATION_DURATION_SECONDS + SHRINK_ANIMATION_DURATION_SECONDS animations:^{
        self.placardView.center = touchPoint;
    }];
    
}


/*
 
 Equivalent implementation using delegate-based method.
 
 - (void)animateFirstTouchAtPointOld:(CGPoint)touchPoint {
 
 #define GROW_ANIMATION_DURATION_SECONDS 0.15
 #define SHRINK_ANIMATION_DURATION_SECONDS 0.15
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
 [UIView setAnimationDelegate:self];
 [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
 CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
 self.placardView.transform = transform;
 [UIView commitAnimations];
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS + SHRINK_ANIMATION_DURATION_SECONDS];
 self.placardView.center = touchPoint;
 [UIView commitAnimations];
 }
 
 
 - (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
 self.placardView.transform = CGAffineTransformMakeScale(1.1, 1.1);
 [UIView commitAnimations];
 }
 */


#endif

- (void)animateOffLeft {
    [UIView animateWithDuration:1.5 animations:^{
        //self.userImageContainer
    } completion:^(BOOL finished) {
        
    }];
}
/**
 Bounce the placard back to the center.
 */
- (void)animatePlacardViewToCenter {
	
    ALog(@"container center %f view center %f", self.userImageContainer.center.y, self.center.y);

    UserImageContainer *userImageContainer = self.userImageContainer;
    CALayer *welcomeLayer = userImageContainer.layer;
	
	// Create a keyframe animation to follow a path back to the center.
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.removedOnCompletion = NO;
	
	CGFloat animationDuration = 0.5f;
	
	// Create the path for the bounces.
	UIBezierPath *bouncePath = [[UIBezierPath alloc] init];
	
    CGPoint centerPoint = _center;
	CGFloat midX = centerPoint.x;
	CGFloat midY = centerPoint.y;
	CGFloat originalOffsetX = userImageContainer.center.x - midX;
	CGFloat originalOffsetY = userImageContainer.center.y - midY;
	CGFloat offsetDivider = 4.0f;
	
	BOOL stopBouncing = NO;
    
	// Start the path at the placard's current location.
	[bouncePath moveToPoint:CGPointMake(userImageContainer.center.x, userImageContainer.center.y)];
	[bouncePath addLineToPoint:CGPointMake(midX, midY)];
	
	// Add to the bounce path in decreasing excursions from the center.
	while (stopBouncing != YES) {
        
        CGPoint excursion = CGPointMake(midX + originalOffsetX/offsetDivider, midY + originalOffsetY/offsetDivider);
        [bouncePath addLineToPoint:excursion];
        [bouncePath addLineToPoint:centerPoint];
        
		offsetDivider += 4;
		animationDuration += 1/offsetDivider;
		if ((abs(originalOffsetX/offsetDivider) < 6) && (abs(originalOffsetY/offsetDivider) < 6)) {
			stopBouncing = YES;
		}
	}
	
	bounceAnimation.path = [bouncePath CGPath];
	bounceAnimation.duration = animationDuration;
	
	// Create a basic animation to restore the size of the placard.
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.removedOnCompletion = YES;
	transformAnimation.duration = animationDuration;
	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	
	
	// Create an animation group to combine the keyframe and basic animations.
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction.
	theGroup.delegate = self;
	theGroup.duration = animationDuration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	theGroup.animations = @[bounceAnimation, transformAnimation];
	
	
	// Add the animation group to the layer.
	[welcomeLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
	
	// Set the placard view's center and transformation to the original values in preparation for the end of the animation.
	userImageContainer.center = centerPoint;
	userImageContainer.transform = CGAffineTransformIdentity;
}


/**
 Animation delegate method called when the animation's finished: restore the transform and reenable user interaction.
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
	self.userImageContainer.transform = CGAffineTransformIdentity;
	self.userInteractionEnabled = YES;
    self.rejectImage.alpha = 0.0;
    self.acceptImage.alpha = 0.0;
}

@end
