//
//  SwipView.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 6/29/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "UserImageContainer.h"
@protocol SwipeViewDelegate;
@interface SwipeView : UIView
@property (nonatomic, strong) IBOutlet UserImageContainer *userImageContainer;
@property (nonatomic) NSUInteger nextDisplayStringIndex;
@property (nonatomic, strong) NSArray *displayStrings;
@property (nonatomic, weak) id <SwipeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *rejectImage;
@property (weak, nonatomic) IBOutlet UIImageView *acceptImage;
@end

@protocol SwipeViewDelegate <NSObject>

@required
- (void)touchesDidBegin;
- (void)touchesDidEnd;
- (IBAction)didTapLike:(id)sender;
- (IBAction)didTapUnlike:(id)sender;
- (IBAction)didTapPhoto:(id)sender;

@end