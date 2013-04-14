//
//  NotificationCell.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "TTTAttributedLabel.h"
#import "ProfileImageView.h"

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *notificationLabel;
@property (weak, nonatomic) IBOutlet ProfileImageView *profilePhotoView;
@property BOOL isNotRead;
@end
