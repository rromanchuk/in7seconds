//
//  ProfileImageView.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "FeedUserImage.h"
#import  <QuartzCore/QuartzCore.h>
#import "UIImageView+additions.h"

@implementation FeedUserImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _notifyImageLoad = NO;
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
    [self.layer setShadowColor:[UIColor grayColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:1.0];
    [self.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 3;
    self.opaque = YES;
    self.backgroundColor = RGBCOLOR(197, 197, 197);
}

- (void)setProfilePhotoWithURL:(NSString *)url {
    NSURLRequest *postcardRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self setImageWithURLRequest:postcardRequest
                placeholderImage:nil
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             ALog(@"image sizie w%f h%f", image.size.width, image.size.height);
                             self.image = image;
                             CGSize actual = [self imageScale];
                             self.clipsToBounds = YES;
                             if (_notifyImageLoad && [self.delegate respondsToSelector:@selector(imageLoaded)]) {
                                 [self.delegate imageLoaded];
                             }
     
                         }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                             DLog(@"Failure setting postcard image with url %@", url);
                         }];
}

- (void)setWithImage:(UIImage *)image {
    self.image = image;
    CGSize actual = [self imageScale];
    self.clipsToBounds = YES;
}




@end
