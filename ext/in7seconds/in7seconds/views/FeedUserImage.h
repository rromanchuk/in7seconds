//
//  ProfileImageView.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

@protocol ImageLoadedDelegate;
@interface FeedUserImage : UIImageView
@property BOOL notifyImageLoad;

@property (weak) id <ImageLoadedDelegate> delegate;
- (void)setProfilePhotoWithURL:(NSString *)url;
- (void)setWithImage:(UIImage *)image;
@end


@protocol ImageLoadedDelegate <NSObject>

@optional
- (void)imageLoaded;

@end