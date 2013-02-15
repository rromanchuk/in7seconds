
@interface UIBarButtonItem (Borderless)
+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)barItemWithView:(UIView *)view target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action selectedImage:(UIImage *)selectedImage highlightedImage:(UIImage *)highlightedImage;
+ (UIBarButtonItem *)notificationBarItemWithImage:(UIImage*)image target:(id)target action:(SEL)action title:(NSString *)title;
@end
