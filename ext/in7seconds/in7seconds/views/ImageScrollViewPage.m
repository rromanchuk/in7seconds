//
//  OKImageScrollViewPage.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 5/9/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ImageScrollViewPage.h"

@implementation ImageScrollViewPage

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        _reuseIdentifier = [reuseIdentifier copy];
        self.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    return self;
}

@end
