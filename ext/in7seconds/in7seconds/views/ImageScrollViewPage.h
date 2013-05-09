//
//  OKImageScrollViewPage.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 5/9/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


@interface ImageScrollViewPage : UIImageView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;
@property (nonatomic) NSUInteger index;
@end
