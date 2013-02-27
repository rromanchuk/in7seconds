//
//  ProfileImageView.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileImageView : UIImageView
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
- (void)setProfilePhotoWithURL:(NSString *)url;
@end
