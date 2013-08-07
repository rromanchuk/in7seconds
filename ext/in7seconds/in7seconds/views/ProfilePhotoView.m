//
//  ProfilePhotoView.m
//  Ostronaut
//
//  Created by Ryan Romanchuk on 8/14/12.
//
//
#import <QuartzCore/QuartzCore.h>
#import "ProfilePhotoView.h"
//#import "Utils.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Resize.h"

@implementation ProfilePhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    //UIColor *pinkColor = RGBCOLOR(242, 95, 114);
    CALayer *backdropLayer = self.layer;
    [backdropLayer setCornerRadius:self.frame.size.width / 2];
    [backdropLayer setBorderWidth:2];
    [backdropLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    //[backdropLayer setMasksToBounds:YES];
    [backdropLayer setShadowColor:[UIColor grayColor].CGColor];
    [backdropLayer setShadowOffset:CGSizeMake(0, 2)];
    [backdropLayer setShadowRadius:2];
    [backdropLayer setShadowOpacity:0.8];
    
    [backdropLayer setShadowPath:
     [[UIBezierPath bezierPathWithRoundedRect:[backdropLayer bounds]
                                 cornerRadius:self.frame.size.width / 2] CGPath]];
    
    //[backdropLayer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
    self.thumbnailSize = [NSNumber numberWithFloat:(self.frame.size.height - 4.0)];
    self.thumbnailSizeForDevice = [NSNumber numberWithFloat:[self sizeForDevice:[self.thumbnailSize floatValue]]];
    self.radius = [NSNumber numberWithFloat:([self.thumbnailSize floatValue]/ 2.0)];
    self.radiusForDevice = [NSNumber numberWithFloat:[self sizeForDevice:[self.radius floatValue]]];
    
    float padding = (self.frame.size.width - (self.frame.size.width - 4.0)) /2;
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, self.frame.size.width - 4.0, self.frame.size.height - 4.0)];
    [self addSubview:self.profileImageView];
    self.profileImageView.image = self.profileImage;
}

- (void)setProfileImageForUser:(User *)user {
    
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:user.photoUrl]];
        [self.profileImageView setImageWithURLRequest:request
                                     placeholderImage:[self placeholderImage]
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  self.profileImageView.image = [ProfilePhotoView roundImage:image thumbnailSizeForDevize:[self.thumbnailSizeForDevice floatValue] radiusForDevice:[self.radiusForDevice floatValue]];
                                                  
                                              }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  self.profileImage = [self placeholderImage];
                                                  ALog(@"Failure loading review profile photo with request %@ and errer %@", request, error);
                                              }];
        
}

+ (UIImage *)roundImage:(UIImage *)profileImage thumbnailSizeForDevize:(float)size radiusForDevice:(float)radius {
    return [profileImage thumbnailImage:size transparentBorder:0 cornerRadius:radius interpolationQuality:kCGInterpolationHigh];
}

- (UIImage *)placeholderImage {
    return [ProfilePhotoView roundImage:[UIImage imageNamed:@"placeholder-profile.png"] thumbnailSizeForDevize:[self.thumbnailSizeForDevice floatValue] radiusForDevice:[self.radiusForDevice floatValue]];
}

- (CGFloat)sizeForDevice:(CGFloat)size {
    // Take Retina display into account
    CGFloat scale = [[UIScreen mainScreen] scale];
    size *= scale;
    return size;
}


@end