//
//  NotificationCell.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *notficationLabel;
@property BOOL isNotRead;
@end
