//
//  ImageBrowser.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 5/9/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ImageBrowser.h"
#import "SSScrollView.h"
@interface ImageBrowser() <ScrollViewDataSource>

@end

@implementation ImageBrowser
{
    SSScrollView *_photoBrowser;
    NSArray      *_images;
    UILabel      *_countLabel;
}

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        
        _photoBrowser = [[SSScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds) - 80)];
        _photoBrowser.dataSource = self;
        [self addSubview:_photoBrowser];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _countLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_countLabel];
    }
    
    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    _photoBrowser.center = CGPointMake(roundf(CGRectGetWidth(self.frame)/2), roundf(CGRectGetHeight(self.frame)/2));
    _countLabel.frame = CGRectOffset(_countLabel.bounds,
                                     CGRectGetWidth(self.frame) - CGRectGetWidth(_countLabel.frame),
                                     CGRectGetHeight(self.frame) - CGRectGetHeight(_countLabel.frame));
}

- (void) setImages:(NSArray *) images {
    
    _images = images;
    
    _countLabel.text = [NSString stringWithFormat:@"%d/%d", [_images count], [_images count]];
    CGSize size = [_countLabel.text sizeWithFont:_countLabel.font];
    
    _countLabel.frame = CGRectMake(0, 0, size.width + 10, CGRectGetHeight(_countLabel.frame));
    [self setNeedsLayout];
    
    [_photoBrowser reloadData];
}


- (NSUInteger)numberOfPagesInScrollView:(SSScrollView *)scrollView {
    return [_images count];
}

- (ImageScrollViewPage *)scrollView:(SSScrollView *)scrollView pageAtIndex:(NSUInteger)index {
    
    ImageScrollViewPage *page = (ImageScrollViewPage *)[scrollView dequeueReusablePageForIdentifier:@"Image"];
    
    if (page == nil) {
        page = [[ImageScrollViewPage alloc] initWithReuseIdentifier:@"Image"];
    }
    
    [page setImageWithURL:[NSURL URLWithString:_images[index]]];
    
    return page;
}

- (void)scrollView:(SSScrollView *)scrollView willDisplayPage:(ImageScrollViewPage *)page {
    [page setNeedsLayout];
}

- (void) scrollView:(SSScrollView *)scrollView didPageAtIndex:(NSUInteger)index
{
    
    _countLabel.text = [NSString stringWithFormat:@"%d/%d", ([_images count] == 0 ? 0 : index+1), [_images count]];
    [self setNeedsLayout];
}

@end
