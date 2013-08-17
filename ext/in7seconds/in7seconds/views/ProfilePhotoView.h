//
//  ProfilePhotoView.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


@interface ProfilePhotoView : UIImageView
@property float deviceSize;
@property float radius;

- (void)setCircleWithUrl:(NSString *)string;
@end
