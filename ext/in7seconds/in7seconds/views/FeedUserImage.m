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

@interface FeedUserImage ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

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
    self.backgroundColor = RGBCOLOR(186, 180, 194);
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
    [self.layer setShadowColor:[UIColor grayColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:1.0];
    [self.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 3;
    self.opaque = YES;
}

- (void)awakeFromNib {
    [self layoutIfNeeded];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width/2) - 10, (self.frame.size.height / 2) - 10, 20.0, 20.0) ];
    [self addSubview:self.activityIndicator];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.activityIndicator.backgroundColor = RGBCOLOR(186, 180, 194);
    self.activityIndicator.opaque = YES;

}

- (void)setProfilePhotoWithURL:(NSString *)url {
    self.image = nil;
    NSURLRequest *postcardRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.activityIndicator startAnimating];
    __weak FeedUserImage *weakSelf = self;
    [self setImageWithURLRequest:postcardRequest
                placeholderImage:nil
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             [weakSelf.activityIndicator stopAnimating];
                             ALog(@"image sizie w%f h%f", image.size.width, image.size.height);
                             weakSelf.image = image;
                             CGSize actual = [weakSelf imageScale];
                             weakSelf.clipsToBounds = YES;
                             if (_notifyImageLoad && [weakSelf.delegate respondsToSelector:@selector(imageLoaded)]) {
                                 [self.delegate imageLoaded];
                             }
     
                         }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                             DLog(@"Failure setting postcard image with url %@", url);
                             [self.activityIndicator stopAnimating];
                         }];
}

- (void)setWithImage:(UIImage *)image {
    [self.activityIndicator stopAnimating];
    self.image = image;
    CGSize actual = [self imageScale];
    self.clipsToBounds = YES;
}




@end
