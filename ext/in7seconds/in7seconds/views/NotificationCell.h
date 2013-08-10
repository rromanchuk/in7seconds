//
//  NotificationCell.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/14/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ProfilePhotoView.m"

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ProfilePhotoView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *notficationLabel;
@property BOOL isNotRead;
@end
