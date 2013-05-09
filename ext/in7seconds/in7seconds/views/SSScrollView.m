//
//  OKScrollView.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 5/9/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "SSScrollView.h"

@interface SSScrollView() <UIScrollViewDelegate>
{
    ImageScrollViewPage *_emptyView;
    
    NSMutableSet *_visiblePages;
    NSMutableSet *_recycledPages;
}

@end

@implementation SSScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        _visiblePages = [[NSMutableSet alloc] init];
        _recycledPages = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    
}

#pragma mark -
- (void) reloadData {
    
    self.contentSize = [self contentSizeForPagingScrollView];
    self.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex];
    
    for (ImageScrollViewPage *page in _visiblePages) {
        [_recycledPages addObject:page];
        [page removeFromSuperview];
    }
	[_visiblePages minusSet:_recycledPages];
    
    [self tilePages];
    
    if ([self.dataSource respondsToSelector:@selector(scrollView:didPageAtIndex:)])
        [self.dataSource scrollView:self didPageAtIndex:self.currentPageIndex];
}

- (void) setCurrentPage:(NSInteger)currentPage animated:(BOOL) animated {
    
    _currentPageIndex = currentPage;
    [self setContentOffset:[self contentOffsetForPageAtIndex:_currentPageIndex] animated:animated];
}

#pragma mark - Paging
- (void)tilePages {
    
	// Calculate which pages should be visible
	// Ignore padding as paging bounces encroach on that
	// and lead to false page loads
	CGRect visibleBounds = self.bounds;
    NSInteger photosCount = [self.dataSource numberOfPagesInScrollView:self];
    
    if ([self.dataSource respondsToSelector:@selector(scrollViewEmptyPage:)]) {
        
        if (photosCount == 0 && _emptyView == nil) {
            
            _emptyView = [self.dataSource scrollViewEmptyPage:self];
            [self configurePage:_emptyView forIndex:0];
            [self addSubview:_emptyView];
            
            return;
        } else if (photosCount != 0 && _emptyView) {
            
            [_emptyView removeFromSuperview], _emptyView = nil;
        }
    } else if (photosCount == 0) {
        
        return;
    }
    
	int iFirstIndex = (int)floorf((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
	int iLastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > photosCount - 1) iFirstIndex = photosCount - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > photosCount - 1) iLastIndex = photosCount - 1;
	
	// Recycle no longer needed pages
	for (ImageScrollViewPage *page in _visiblePages) {
		if (page.index < (NSUInteger)iFirstIndex || page.index > (NSUInteger)iLastIndex) {
			[_recycledPages addObject:page];
            
			[page removeFromSuperview];
			/*NSLog(@"Removed page at index %i", page.index);*/
		}
	}
	[_visiblePages minusSet:_recycledPages];
    
	// Add missing pages
	for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
		if (![self isDisplayingPageForIndex:index]) {
            
            ImageScrollViewPage *page = [self.dataSource scrollView:self pageAtIndex:index];
			[self configurePage:page forIndex:index];
            
            if ([self.dataSource respondsToSelector:@selector(scrollView:willDisplayPage:)])
                [self.dataSource scrollView:self willDisplayPage:page];
            
            [self addSubview:page];
            
			[_visiblePages addObject:page];
			
			/*NSLog(@"Added page at index %i", page.index);*/
		}
	}
}

#pragma mark - Layout subviews

- (ImageScrollViewPage *) dequeueReusablePageForIdentifier:(NSString *)identifier {
    
	__block ImageScrollViewPage *page = nil;
    
    [_recycledPages enumerateObjectsUsingBlock:^(ImageScrollViewPage *obj, BOOL *stop) {
        if ([obj.reuseIdentifier isEqual:identifier]){
            page = obj;
            *stop = YES;
        }
    }];
    
	if (page)
		[_recycledPages removeObject:page];
	
	return page;
}

- (ImageScrollViewPage *) pageForIdentifier:(NSString *)identifier {
    
	__block ImageScrollViewPage *page = nil;
    
    [_visiblePages enumerateObjectsUsingBlock:^(ImageScrollViewPage *obj, BOOL *stop) {
        if ([obj.reuseIdentifier isEqual:identifier]){
            page = obj;
            *stop = YES;
        }
    }];
    
    return page;
}

- (void)configurePage:(ImageScrollViewPage *)page forIndex:(NSUInteger)index{
	page.frame = [self frameForPageAtIndex:index];
	page.index = index;
    /*NSLog(@"Configure page at index %i", index);*/
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index{
	for (ImageScrollViewPage *page in _visiblePages)
		if (page.index == index) return YES;
    
	return NO;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index{
    CGRect bounds = self.bounds;
    CGRect pageFrame = bounds;
    pageFrame.origin.x = bounds.size.width * index;
    return pageFrame;
}

#pragma mark - Tools
- (CGSize)contentSizeForPagingScrollView{
    NSInteger photosCount = [self.dataSource numberOfPagesInScrollView:self];
    CGRect bounds = self.bounds;
    return CGSizeMake(bounds.size.width * photosCount, bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index{
	CGFloat pageWidth = self.bounds.size.width;
	CGFloat newOffset = index * pageWidth;
	return CGPointMake(newOffset, 0);
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
	// Tile pages
	[self tilePages];
    
    NSInteger photosCount = [self.dataSource numberOfPagesInScrollView:self];
    
    // Calculate current page
	CGRect visibleBounds = self.bounds;
	int index = (int)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
	if (index > photosCount - 1) index = photosCount - 1;
    
	_currentPageIndex = index;
    
    if (!scrollView.decelerating)
        [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([self.dataSource respondsToSelector:@selector(scrollView:didPageAtIndex:)])
        [self.dataSource scrollView:self didPageAtIndex:self.currentPageIndex];
}

@end