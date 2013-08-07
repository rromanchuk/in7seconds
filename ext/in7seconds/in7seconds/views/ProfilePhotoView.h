//
//  ProfilePhotoView.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+Rest.h"

@interface ProfilePhotoView : UIView
@property NSNumber *thumbnailSize;
@property NSNumber *thumbnailSizeForDevice;
@property NSNumber *radius;
@property NSNumber *radiusForDevice;
@property (strong, nonatomic) UIImage *profileImage;

@property UIImageView *profileImageView;

- (void)setProfileImageForUser:(User *)user;
+ (UIImage *)roundImage:(UIImage *)profileImage thumbnailSizeForDevize:(float)size radiusForDevice:(float)radius;
@end

