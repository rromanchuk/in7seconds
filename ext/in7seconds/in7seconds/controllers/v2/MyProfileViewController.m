//
//  MyProfileViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 8/11/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "MyProfileViewController.h"
#import <ViewDeck/IIViewDeckController.h>

#import "UIImage+Resize.h"

@interface MyProfileViewController ()
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property BOOL isFetching;
@end

@implementation MyProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Профиль";
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

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 20;
    self.navigationItem.leftBarButtonItems = @[space, [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"sidebar_button"] target:self action:@selector(revealMenu:)]];
    
    
    ALog(@"birthday %@", self.currentUser.birthday);
    if (self.currentUser.birthday && [self.currentUser.yearsOld integerValue] > 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@, %@ %@", self.currentUser.firstName, self.currentUser.yearsOld, NSLocalizedString(@"лет", @"years old")];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@", self.currentUser.firstName];
    }

    
    [self.myPhoto setCircleWithUrl:self.currentUser.photoUrl];
    ALog(@"setting image for user profile %@", self.currentUser.photoUrl);
    NSInteger ctr = 0;
    for (Image *image in self.currentUser.images) {
        
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self update];
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

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

}

- (IBAction)revealMenu:(id)sender
{
    [self.viewDeckController toggleLeftView];
}



#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pictureFromLibrary:(id)sender {
    self.imagePicker = [[UIImagePickerController alloc] init];
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




@end
