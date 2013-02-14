//
//  MenuViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "User+REST.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *iAmLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
@property (weak, nonatomic) IBOutlet UIButton *lookingForMen;
@property (weak, nonatomic) IBOutlet UIButton *lookingForWomen;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end
