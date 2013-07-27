//
//  MenuViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MenuViewController.h"
#import "RestUser.h"
#import "AppDelegate.h"
#import "User+REST.h"
#import "IndexViewController.h"
#import "UIImage+Resize.h"
#import "UAPushUI.h"


@interface MenuViewController () {
    BOOL _filtersChanged;
    BOOL _isFetching;
}
@property UIImagePickerController *imagePicker;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.datePicker = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
    [self.logoutButton setTitle:NSLocalizedString(@"Выйти", @"logout button text") forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor darkBackgroundColor];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = infoDictionary[@"CFBundleShortVersionString"];
    NSString *minorVersion = infoDictionary[@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@)", majorVersion, minorVersion];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewWillAppear) name:@"ECSlidingViewUnderLeftWillAppear" object:nil];
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedAppDelegate.managedObjectContext;
    [self setupProfile];
    [self setupSegmentControl];
    
    self.profileImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureFromLibrary:)];
    [self.profileImage addGestureRecognizer:tap];
    
    //[UAPush openApnsSettings:self animated:YES];
}


- (void)leftViewWillAppear {
    self.currentUser = [User currentUser:self.managedObjectContext];
    [self setupProfile];
    ALog(@"left view will appear with user %@ and managedObject %@", self.currentUser, self.managedObjectContext);
}


- (void)setupProfile {
    ALog(@"setting up profile for %@", self.currentUser);
    [self.profileImage setProfilePhotoWithURL:self.currentUser.photoUrl];
    if (self.currentUser.birthday && [self.currentUser.yearsOld integerValue] > 0) {
        [self.birthdayButton setTitle:[NSString stringWithFormat:@"%@ %@", self.currentUser.yearsOld, NSLocalizedString(@"лет", @"years old")] forState:UIControlStateNormal];
    } else {
        [self.birthdayButton setTitle:@"Выставите свой возраст в настройках" forState:UIControlStateNormal];
    }

    self.nameLabel.text = self.currentUser.fullName;
    self.emailTextField.text = self.currentUser.email;
    self.notificationEmailSwitch.on = [self.currentUser.emailOptIn boolValue];
    self.notificationPushSwitch.on = [self.currentUser.pushOptIn boolValue];
    // Do any additional setup after loading the view.
    if ([self.currentUser.lookingForGender integerValue] == LookingForBoth) {
        self.lookingForMen.selected = YES;
        self.lookingForWomen.selected = YES;
    } else if ([self.currentUser.lookingForGender integerValue] == LookingForMen) {
        self.lookingForMen.selected = YES;
        self.lookingForWomen.selected = NO;
    } else {
        self.lookingForWomen.selected = YES;
        self.lookingForMen.selected = NO;
    }
    self.genderSegmentControl.selectedSegmentIndex = [self.currentUser.gender integerValue];
}

- (IBAction)notificationSettingsChanged:(id)sender {
    _filtersChanged = YES;
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch == self.notificationEmailSwitch) {
        self.currentUser.emailOptIn = @(self.notificationEmailSwitch.on);
    } else {
        self.currentUser.pushOptIn = @(self.notificationPushSwitch.on);
    }
    [self saveContext];
    [self update];
}

- (IBAction)didTapBirthday:(id)sender {
    
    self.datePicker.delegate = self;
    self.datePicker.datePicker.date = self.currentUser.birthday;
    [self presentSemiModalViewController:self.datePicker];
}


- (void)datePickerSetDate:(TDDatePickerController*)viewController {
    ALog(@"set date");
    [self dismissSemiModalViewController:viewController];
    self.currentUser.birthday = viewController.datePicker.date;
    [self.birthdayButton setTitle:[NSString stringWithFormat:@"%@ %@", self.currentUser.yearsOld, NSLocalizedString(@"лет", @"years old")] forState:UIControlStateNormal];
    [self update];
}

- (void)datePickerClearDate:(TDDatePickerController*)viewController {
    ALog(@"clear date");
    viewController.datePicker.date = self.currentUser.birthday;
    //[viewController dismissModalViewControllerAnimated:YES];

}

- (void)datePickerCancel:(TDDatePickerController*)viewController {
    ALog(@"did cancel");
    [self dismissSemiModalViewController:viewController];
}

- (IBAction)didTapLogout:(id)sender {
    ALog(@"did tap logout sending to delegate %@", self.delegate);
    [self.delegate didLogout];
}

- (IBAction)didTapWomen:(id)sender {
    _filtersChanged = YES;
    self.lookingForWomen.selected = !self.lookingForWomen.selected;
    [self setLookingFor];
    [self update];
}


- (IBAction)didTapMen:(id)sender {
    _filtersChanged = YES;
    self.lookingForMen.selected = !self.lookingForMen.selected;
    [self setLookingFor];
    [self update];
}

- (void)setLookingFor {
    if ((self.lookingForMen.selected && self.lookingForWomen.selected) || (!self.lookingForMen.selected && !self.lookingForWomen.selected)) {
        self.currentUser.lookingForGender = @(LookingForBoth);
    } else if (self.lookingForWomen.selected) {
        self.currentUser.lookingForGender = @(LookingForWomen);
    } else {
        self.currentUser.lookingForGender = @(LookingForMen);
    }    
}

- (void)update {
    [self.managedObjectContext performBlock:^{
        _isFetching  = YES;
        [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
            [SVProgressHUD dismiss];
            self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
            
            NSError *error;
            [self.managedObjectContext save:&error];
            
            AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedAppDelegate writeToDisk];
            
            if (_filtersChanged) {
                ALog(@"filters changed with delegate %@", self.settingsDelegate);
                [self.settingsDelegate didChangeFilters];
                _filtersChanged = NO;
            }
            _isFetching = NO;
        } onError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            _isFetching = NO;
        }];
    }];
    
}

- (IBAction)genderChanged:(id)sender {
    self.currentUser.gender = @(self.genderSegmentControl.selectedSegmentIndex);
    [self update];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharedAppDelegate writeToDisk];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.currentUser.email = self.emailTextField.text;
    NSArray *chunks = [self.nameLabel.text componentsSeparatedByString: @" "];
    if ([chunks count] == 2) {
        self.currentUser.lastName = chunks[1];
        self.currentUser.firstName = chunks[0];
    }
    [textField resignFirstResponder];
    [self update];
    return YES;
}

- (void)setupSegmentControl {
    //[self.genderSegmentControl setFrame:CGRectMake(self.genderSegmentControl.frame.origin.x, self.genderSegmentControl.frame.origin.y, 249, 44)];
    UIImage *segmentSelected = [[UIImage imageNamed:@"selected_control"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 8, 9, 8) resizingMode:UIImageResizingModeStretch];
    UIImage *segmentUnselected = [[UIImage imageNamed:@"unselected_control"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 8, 9, 8) resizingMode:UIImageResizingModeStretch];
    
    UIImage *segmentSelectedUnselected = [[UIImage imageNamed:@"center_left_select"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 5, 0)];
    UIImage *segUnselectedSelected = [[UIImage imageNamed:@"center_right_select"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 5, 0)];
    UIImage *segmentUnselectedUnselected = [[UIImage imageNamed:@"center_noselect"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 5, 0)];
    [self.genderSegmentControl setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.genderSegmentControl setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    //    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segUnselectedSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    NSDictionary *attributes = @{UITextAttributeFont: [UIFont boldSystemFontOfSize:15],
                                UITextAttributeTextColor: RGBCOLOR(24, 23, 20),
                                UITextAttributeTextShadowColor: [UIColor clearColor],
                                UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]};
    [self.genderSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    [self.genderSegmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //    [self.genderSegmentControl setBackgroundImage:[[UIImage imageNamed:@"segment"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 0, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [self.genderSegmentControl setBackgroundImage:[UIImage imageNamed:@"segment-selected"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

}

#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    //self.slidingViewController
}

- (IBAction)pictureFromLibrary:(id)sender {
   self.imagePicker = [[UIImagePickerController alloc] init];
    //imagePicker.showsCameraControls = YES;
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    //[self presentModalViewController:self.imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        [self.imagePicker dismissViewControllerAnimated:NO completion:nil];
        CGRect cropRect = [[info valueForKey:UIImagePickerControllerCropRect] CGRectValue];
        // don't try to juggle around orientation, rotate from the beginning if needed
        UIImage *image = [info[@"UIImagePickerControllerOriginalImage"] fixOrientation];
//    
        image = [image croppedImage:cropRect];
    //
    //    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //    [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
    //             resultBlock:^(ALAsset *asset) {
    //                 NSDictionary *test = [[asset defaultRepresentation] metadata];
    //                 ALog(@"dict from test %@", test);
    //                 ALog(@"gps dict %@", [test objectForKey:@"{GPS}"]);
    //                 NSDictionary *gps = [test objectForKey:@"{GPS}"];
    //                 if (gps) {
    //                     double lon = [((NSString *)[gps objectForKey:@"Longitude"]) doubleValue];
    //                     double lat = [((NSString *)[gps objectForKey:@"Latitude"]) doubleValue];
    //                     if ([[gps objectForKey:@"LongitudeRef"] isEqualToString:@"W"]) {
    //                        lon = lon * -1.0;
    //                     }
    //                     if ([[gps objectForKey:@"LatitudeRef"] isEqualToString:@"S"]) {
    //                        lat = lat * -1.0;
    //                     }
    //                     [[ThreadedUpdates shared] loadPlacesPassivelyWithLat:[NSNumber numberWithDouble:lat] andLon:[NSNumber numberWithDouble:lon]];
    //                     self.exifData = [[NSMutableDictionary alloc]
    //                                      initWithDictionary:@{@"lat" : [NSNumber numberWithDouble:lat], @"lon": [NSNumber numberWithDouble:lon]}
    //                                    ];
    //
    //                     [[Location sharedLocation] getCityCountryWithLat:lat andLon:lon success:^(NSString* cityCountry){
    //                         [self.exifData setValue:cityCountry forKey:@"cityCountryString"];
    //                     }];
    //                 }
    //
    //
    //                 ALAssetRepresentation *image_representation = [asset defaultRepresentation];
    //
    //                 // create a buffer to hold image data
    //                 uint8_t *buffer = (Byte*)malloc(image_representation.size);
    //                 NSUInteger length = [image_representation getBytes:buffer fromOffset: 0.0  length:image_representation.size error:nil];
    //
    //                 if (length != 0)  {
    //
    //                     // buffer -> NSData object; free buffer afterwards
    //                     NSData *adata = [[NSData alloc] initWithBytesNoCopy:buffer length:image_representation.size freeWhenDone:YES];
    //
    //                     // identify image type (jpeg, png, RAW file, ...) using UTI hint
    //                     NSDictionary* sourceOptionsDict = [NSDictionary dictionaryWithObjectsAndKeys:(id)[image_representation UTI] ,kCGImageSourceTypeIdentifierHint,nil];
    //
    //                     // create CGImageSource with NSData
    //                     CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef) adata,  (__bridge CFDictionaryRef) sourceOptionsDict);
    //
    //                     // get imagePropertiesDictionary
    //                     CFDictionaryRef imagePropertiesDictionary;
    //                     imagePropertiesDictionary = CGImageSourceCopyPropertiesAtIndex(sourceRef,0, NULL);
    //                     self.metaData = [[NSMutableDictionary alloc] initWithDictionary: (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(sourceRef,0,NULL)];
    //
    //                 }
    //                 else {
    //                     NSLog(@"image_representation buffer length == 0");
    //                 }
    //             }
    //            failureBlock:^(NSError *error) {
    //                NSLog(@"couldn't get asset: %@", error);
    //            }
    //     ];
    //
    //
    //
    //
        DLog(@"Coming back with image");
    
        DLog(@"Size of image is height: %f, width: %f", image.size.height, image.size.width);
        CGSize size = image.size;
        if (size.width < 640.0 && size.height < 640.0) {
   
        } else {
            // This image needs to be scaled and cropped into a square image
            CGFloat centerX = size.width / 2;
            CGFloat centerY = size.height / 2;
            if (size.width > size.height) {
                image = [image croppedImage:CGRectMake(centerX - size.height / 2 , 0, size.height, size.height)];
            } else {
                image = [image croppedImage:CGRectMake(0 , centerY - size.width / 2, size.width, size.width)];
            }
            image = [image resizedImage:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationHigh];
    
        }
    NSMutableData *imageData = [UIImageJPEGRepresentation(image, 0.9) mutableCopy];
    [RestUser addPhoto:imageData  onLoad:^(RestUser *restUser) {
        
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setNotificationEmailSwitch:nil];
    [self setNotificationPushSwitch:nil];
    [self setDatePicker:nil];
    [self setBirthdayButton:nil];
    [super viewDidUnload];
}
@end
