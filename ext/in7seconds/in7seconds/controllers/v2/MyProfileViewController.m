//
//  MyProfileViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/11/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MyProfileViewController.h"
#import <ViewDeck/IIViewDeckController.h>
#import "GAI.h"
#import "UIImage+Resize.h"

@interface MyProfileViewController ()
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property BOOL isFetching;
@property NSInteger currentSelectedPhoto;
@end

@implementation MyProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusTextField.delegate = self;
    self.title = NSLocalizedString(@"Профиль", nil);
    UITapGestureRecognizer *gr1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureFromLibrary:)];
    [self.myPicture1 addGestureRecognizer:gr1];
    self.myPicture1.tag = 1;
    
    UITapGestureRecognizer *gr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureFromLibrary:)];
    [self.myPicture2 addGestureRecognizer:gr2];
    self.myPicture2.tag = 2;
    
    UITapGestureRecognizer *gr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureFromLibrary:)];
    [self.myPicture3 addGestureRecognizer:gr3];
    self.myPicture3.tag = 3;

    UITapGestureRecognizer *gr4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureFromLibrary:)];
    [self.myPicture4 addGestureRecognizer:gr4];
    self.myPicture4.tag = 4;

    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        space.width = 20;
        self.navigationItem.leftBarButtonItems = @[space, [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];
        
    } else {
        self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];
    }

    ALog(@"status is %@", self.currentUser.status);
    if (self.currentUser.status.length > 0 ) {
        self.statusTextField.text = self.currentUser.status;
    }
    self.genderSegment.selectedSegmentIndex = [self.currentUser.gender integerValue];
    ALog(@"birthday %@", self.currentUser.birthday);
    if (self.currentUser.birthday && [self.currentUser.yearsOld integerValue] > 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@, %@ %@", self.currentUser.firstName, self.currentUser.yearsOld, NSLocalizedString(@"лет", @"years old")];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@", self.currentUser.firstName];
    }

    
    [self.myPhoto setCircleWithUrl:self.currentUser.photoUrl];
    [self reloadUserImages];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"My Profile Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)update {
    [self.managedObjectContext performBlock:^{
        _isFetching  = YES;
        [RestUser update:self.currentUser onLoad:^(RestUser *restUser) {
            [SVProgressHUD dismiss];
            self.currentUser = [User userWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
            
            NSError *error;
            [self.managedObjectContext save:&error];
            
                       
            _isFetching = NO;
        } onError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            _isFetching = NO;
        }];
    }];
    
}


- (IBAction)genderChanged:(id)sender {
    self.currentUser.gender = @(self.genderSegment.selectedSegmentIndex);
    [self update];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

}

- (IBAction)revealMenu:(id)sender
{
    self.currentUser.status = self.statusTextField.text;
    [self update];
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}


- (void)reloadUserImages {
    ALog(@"setting image for user profile %@", self.currentUser.photoUrl);
    NSInteger ctr = 0;
    for (Image *image in self.currentUser.images) {
        switch (ctr) {
            case 0:
                [self.myPicture1 setCircleWithUrl:image.photoUrl];
                break;
            case 1:
                [self.myPicture2 setCircleWithUrl:image.photoUrl];
                break;
            case 2:
                [self.myPicture3 setCircleWithUrl:image.photoUrl];
                break;
            case 3:
                [self.myPicture4 setCircleWithUrl:image.photoUrl];
                break;
            default:
                break;
        }
        ctr++;
    }

}
#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pictureFromLibrary:(id)sender {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.currentSelectedPhoto = ((UIImageView *)((UIGestureRecognizer *)sender).view).tag;
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
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

- (IBAction)statusDidChange:(id)sender {
    self.currentUser.status = self.statusTextField.text;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
