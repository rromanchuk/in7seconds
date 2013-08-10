//
//  OtherUserChatCell.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "BlueBubble.h"
@interface OtherUserChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *otherUserText;
@property (weak, nonatomic) IBOutlet UIView *otherUserBubble;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
