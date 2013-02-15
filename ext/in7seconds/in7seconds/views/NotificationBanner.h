//
//  NotificationBanner.h
//  Ostronaut
//
//  Created by Ryan Romanchuk on 11/30/12.
//
//

#import "Match+REST.h"
@interface NotificationBanner : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *notificationTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *dismissButton;


@property (strong, nonatomic) Match *match;
@property (strong, nonatomic) id sender;

@property (strong, nonatomic) NSString *segueTo;
- (void)setupView;

@end
