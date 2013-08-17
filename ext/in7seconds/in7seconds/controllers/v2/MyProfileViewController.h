//
//  MyProfileViewController.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/11/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ProfilePhotoView.h"
#import "User+REST.h"
#import "Image+REST.h"

@interface MyProfileViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) User *currentUser;

@property (weak, nonatomic) IBOutlet ProfilePhotoView *myPhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *myPicture1;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *myPicture2;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *myPicture3;
@property (weak, nonatomic) IBOutlet ProfilePhotoView *myPicture4;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
- (IBAction)genderChanged:(id)sender;
@end
