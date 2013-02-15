//
//  CurrentUserChatCell.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "WhiteBubble.h"

@interface CurrentUserChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currentUserText;
@property (weak, nonatomic) IBOutlet UIView *whiteBubble;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
