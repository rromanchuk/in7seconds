//
//  CurrentUserChatCell.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "WhiteBubble.h"

@interface CurrentUserChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet WhiteBubble *whiteBubble;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;

@end
