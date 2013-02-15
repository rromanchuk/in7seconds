//
//  MenuViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/7/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


#import "User+REST.h"
#import "ProfilePhotoView.h"
#import "CircleView.h"
@interface MenuViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *profilePhoto;
@property (weak, nonatomic) IBOutlet CircleView *notificationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numNotificationsLabel;
@property (strong, nonatomic) User *currentUser;
@end



