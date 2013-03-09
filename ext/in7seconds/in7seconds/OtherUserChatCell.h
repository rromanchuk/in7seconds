//
//  OtherUserChatCell.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueBubble.h"
@interface OtherUserChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BlueBubble *blueBubble;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
