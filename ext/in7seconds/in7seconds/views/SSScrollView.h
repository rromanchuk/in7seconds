
#import "ImageScrollViewPage.h"

@protocol ScrollViewDataSource;
@interface SSScrollView : UIScrollView

@property (nonatomic, weak) id<ScrollViewDataSource> dataSource;
@property (nonatomic) NSInteger currentPageIndex;

// Данный метод работает очень ограничено
- (void) setCurrentPage:(NSInteger)currentPage animated:(BOOL) animated;

- (ImageScrollViewPage *) dequeueReusablePageForIdentifier:(NSString *)identifier;
- (ImageScrollViewPage *) pageForIdentifier:(NSString *)identifier;

- (void) reloadData;

@end


@protocol ScrollViewDataSource <NSObject>
@required
- (NSUInteger)numberOfPagesInScrollView:(SSScrollView *)scrollView;
- (ImageScrollViewPage *)scrollView:(SSScrollView *)scrollView pageAtIndex:(NSUInteger)index;

@optional
- (void) scrollView:(SSScrollView *)scrollView didPageAtIndex:(NSUInteger)index;
- (ImageScrollViewPage *) scrollViewEmptyPage:(SSScrollView *)scrollView;
- (void)scrollView:(SSScrollView *)scrollView willDisplayPage:(ImageScrollViewPage*)page;
@end
