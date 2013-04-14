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
@interface MenuViewController () {
    BOOL _filtersChanged;
}
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.logoutButton setTitle:NSLocalizedString(@"Выйти", @"logout button text") forState:UIControlStateNormal];
    
    [self.slidingViewController setAnchorRightRevealAmount:295.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    self.view.backgroundColor = [UIColor darkBackgroundColor];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@)", majorVersion, minorVersion];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewWillAppear) name:@"ECSlidingViewUnderLeftWillAppear" object:nil];
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedAppDelegate.managedObjectContext;
    [self setupProfile];
    [self setupSegmentControl];
    
    self.profileImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureFromLibrary:)];
    [self.profileImage addGestureRecognizer:tap];
}


- (void)leftViewWillAppear {
    self.currentUser = [User currentUser:self.managedObjectContext];
    [self setupProfile];
    ALog(@"left view will appear with user %@ and managedObject %@", self.currentUser, self.managedObjectContext);
}


- (void)setupProfile {
    ALog(@"setting up profile for %@", self.currentUser);
    [self.profileImage setProfilePhotoWithURL:self.currentUser.photoUrl];
    self.nameTextField.text = self.currentUser.fullName;
    self.emailTextField.text = self.currentUser.email;
    // Do any additional setup after loading the view.
    if ([self.currentUser.lookingForGender integerValue] == LookingForBoth) {
        self.lookingForMen.selected = YES;
        self.lookingForWomen.selected = YES;
    } else if ([self.currentUser.lookingForGender integerValue] == LookingForMen) {
        self.lookingForMen.selected = YES;
    } else {
        self.lookingForWomen.selected = YES;
    }
    self.genderSegmentControl.selectedSegmentIndex = [self.currentUser.gender integerValue];
}

- (IBAction)didTapLogout:(id)sender {
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
        self.currentUser.lookingForGender = [NSNumber numberWithInteger:LookingForBoth];
    } else if (self.lookingForWomen.selected) {
        self.currentUser.lookingForGender = [NSNumber numberWithInteger:LookingForWomen];
    } else {
        self.currentUser.lookingForGender = [NSNumber numberWithInteger:LookingForMen];
    }    
}


- (void)update {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...")];
    [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
        [SVProgressHUD dismiss];
        self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
        [self saveContext];
        if (_filtersChanged) {
            [self.delegate didChangeFilters];
            _filtersChanged = NO;
        }
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)genderChanged:(id)sender {
    self.currentUser.gender = [NSNumber numberWithInteger:self.genderSegmentControl.selectedSegmentIndex];
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
    NSArray *chunks = [self.nameTextField.text componentsSeparatedByString: @" "];
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
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:15], UITextAttributeFont,
                                RGBCOLOR(24, 23, 20), UITextAttributeTextColor,
                                [UIColor clearColor], UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                nil];
    [self.genderSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.genderSegmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //    [self.genderSegmentControl setBackgroundImage:[[UIImage imageNamed:@"segment"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 0, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [self.genderSegmentControl setBackgroundImage:[UIImage imageNamed:@"segment-selected"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

}

#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pictureFromLibrary:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.showsCameraControls = YES;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//        [self dismissModalViewControllerAnimated:NO];
//        CGRect cropRect = [[info valueForKey:UIImagePickerControllerCropRect] CGRectValue];
//        // don't try to juggle around orientation, rotate from the beginning if needed
//        UIImage *image = [[info objectForKey:@"UIImagePickerControllerOriginalImage"] fixOrientation];
//    
//        image = [image croppedImage:cropRect];
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
    //    DLog(@"Coming back with image");
    //
    //    DLog(@"Size of image is height: %f, width: %f", image.size.height, image.size.width);
    //    CGSize size = image.size;
    //    if (size.width < 640.0 && size.height < 640.0) {
    //        // The image is so small it doesn't need to be resized, this isn't great because it will forcefully scaled up.
    //        self.imageFromLibrary = image;
    //        [self didFinishPickingFromLibrary:self];
    //    } else {
    //        // This image needs to be scaled and cropped into a square image
    //        CGFloat centerX = size.width / 2;
    //        CGFloat centerY = size.height / 2;
    //        if (size.width > size.height) {
    //            image = [image croppedImage:CGRectMake(centerX - size.height / 2 , 0, size.height, size.height)];
    //        } else {
    //            image = [image croppedImage:CGRectMake(0 , centerY - size.width / 2, size.width, size.width)];
    //        }
    //        self.imageFromLibrary = [image resizedImage:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationHigh];
    //        
    //        [self didFinishPickingFromLibrary:self];
    //    }
    //    
}


@end
