//
//  MenuViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/7/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


#import "User+REST.h"
#import "ProfilePhotoView.h"
@interface MenuViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *profilePhoto;
@property (strong, nonatomic) User *currentUser;
@end



