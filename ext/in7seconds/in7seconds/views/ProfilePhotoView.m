//
//  ProfilePhotoView.m
//  Ostronaut
//
//  Created by Ryan Romanchuk on 8/14/12.
//
//
#import <QuartzCore/QuartzCore.h>
#import "ProfilePhotoView.h"
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

- (void)setCircleWithUrl:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"alena"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //self.image = image;
        float radius = [self sizeForDevice:(self.frame.size.width / 2.0)];
        float size = [self sizeForDevice:self.frame.size.width];
        self.image = [image thumbnailImage:size transparentBorder:0 cornerRadius:radius interpolationQuality:kCGInterpolationHigh];
        //[self setRoundedView:self toDiameter:50];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

- (void)commonInit {
   
}

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (CGFloat)sizeForDevice:(CGFloat)size {
    // Take Retina display into account
    CGFloat scale = [[UIScreen mainScreen] scale];
    size *= scale;
    return size;
}

@end