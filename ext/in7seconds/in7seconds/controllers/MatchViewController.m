//
//  MatchViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MatchViewController.h"

@interface MatchViewController ()

@end

@implementation MatchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.otherUserImage setImageWithURL:[NSURL URLWithString:self.otherUser.photoUrl]];
    [self.currentUserImage setImageWithURL:[NSURL URLWithString:self.currentUser.photoUrl]];
    
    NSString *message = ([self.otherUser.gender boolValue]) ? @"ответила" : @"ответил";
    self.matchTextLabel.text = [NSString stringWithFormat:@"%@ %@ взаимностью!", self.otherUser.fullName, message];
	// Do any additional setup after loading the view.
}


- (IBAction)didTapStartChat:(id)sender {
    [self.delegate userWantsToChat];
}

- (IBAction)didTapKeepSearching:(id)sender {
    [self.delegate userWantsToRate];
}
@end

