//
//  ProfileImageView.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageLoadedDelegate;
@interface ProfileImageView : UIImageView
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak) id <ImageLoadedDelegate> delegate;
- (void)setProfilePhotoWithURL:(NSString *)url;
- (void)setWithImage:(UIImage *)image;
@end


@protocol ImageLoadedDelegate <NSObject>

@required
- (void)imageLoaded;

@end