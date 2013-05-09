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
}

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        
        _photoBrowser = [[SSScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds) - 80)];
        _photoBrowser.dataSource = self;
        [self addSubview:_photoBrowser];
    }
    
    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    _photoBrowser.center = CGPointMake(roundf(CGRectGetWidth(self.frame)/2), roundf(CGRectGetHeight(self.frame)/2));
}

- (void) setImages:(NSArray *) images {
    
    _images = images;
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

- (void) scrollView:(SSScrollView *)scrollView didPageAtIndex:(NSUInteger)index {}

@end
