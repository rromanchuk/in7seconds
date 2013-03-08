//
//  ProfileImageView.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ProfileImageView.h"
#import  <QuartzCore/QuartzCore.h>
#import "UIImageView+additions.h"

@implementation ProfileImageView

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
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
    [self.layer setShadowColor:[UIColor grayColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:1.0];
    [self.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width/2) - 10, (self.frame.size.height / 2) - 10, 20.0, 20.0) ];
    [self addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.activityIndicator.backgroundColor = RGBCOLOR(197, 197, 197);
    self.activityIndicator.opaque = YES;
    self.opaque = YES;
    self.backgroundColor = RGBCOLOR(197, 197, 197);
}

- (void)setProfilePhotoWithURL:(NSString *)url {
    NSURLRequest *postcardRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self setImageWithURLRequest:postcardRequest
                placeholderImage:nil
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             ALog(@"image sizie w%f h%f", image.size.width, image.size.height);
                             [self.activityIndicator stopAnimating];
                             self.image = image;
                             CGSize actual = [self imageScale];
                             self.clipsToBounds = YES;
                             [self.delegate imageLoaded];
                             
                         }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                             [self.activityIndicator stopAnimating];
                             DLog(@"Failure setting postcard image with url %@", url);
                         }];
}

- (void)setWithImage:(UIImage *)image {
    [self.activityIndicator stopAnimating];
    self.image = image;
    CGSize actual = [self imageScale];
    self.clipsToBounds = YES;
}




@end
