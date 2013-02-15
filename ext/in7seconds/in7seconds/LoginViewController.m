//
//  LoginViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "LoginViewController.h"
#import "IndexViewController.h"
#import "BaseNavigationViewController.h"
#import "RestUser.h"
#import "AppDelegate.h"
#import "UAPush.h"
#import "UAirship.h"
#import "MenuViewController.h"
#import "ThreadedUpdates.h"
#import <ViewDeck/IIViewDeckController.h>

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.navigationController.navigationBarHidden = YES;
    
    [Vkontakte sharedInstance].delegate = self;
    [FacebookHelper shared].delegate = self;
    self.loginLabel.text = NSLocalizedString(@"Войти через Вконтакте", @"Login with vk prompt");
    [[Vkontakte sharedInstance] logout];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Login Screen";
}

- (IBAction)didTapVkLogin:(id)sender {
    ALog(@"did tap");
    if (![[Vkontakte sharedInstance] isAuthorized])
    {
        ALog(@"authenticate");
        [[Vkontakte sharedInstance] authenticate];
    }
}

- (IBAction)didTapFbLogin:(id)sender {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...") maskType:SVProgressHUDMaskTypeGradient];
    [[FacebookHelper shared] login];
}

#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
    [[Vkontakte sharedInstance] logout];
    [RestUser resetIdentifiers];
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VK_LOGIN_ERROR", @"Error when trying to authenticate vk")];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showVkontakteAuthController:(UIViewController *)controller
{
    self.vkController = controller;
    [self presentViewController:controller animated:YES completion:^(void) {
        
    }];
}

- (void)vkontakteAuthControllerDidCancelled
{
    [RestUser resetIdentifiers];
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
    ALog(@"vk did finish logging in");

    NSDictionary *_params = @{@"access_token": vkontakte.accessToken, @"user_id": vkontakte.userId, @"platform": @"vkontakte", @"email": vkontakte.email };
    NSMutableDictionary *params = [_params mutableCopy];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загрузка...", @"Loading...") maskType:SVProgressHUDMaskTypeGradient];
    
    [RestUser create:params
              onLoad:^(RestUser *restUser) {
                  User *user = [User findOrCreateUserWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
                  self.currentUser = user;
                  [RestUser setCurrentUserId:restUser.externalId];
                  [RestUser setCurrentUserToken:restUser.authenticationToken];
                  [self setIdentifiers:user];
                  [SVProgressHUD dismiss];
                  [self setupProfile];
                  [self.vkController dismissViewControllerAnimated:YES completion:nil];
              }
             onError:^(NSError *error) {
                 [SVProgressHUD dismiss];
                 [RestUser resetIdentifiers];
                 [[Vkontakte sharedInstance] logout];
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [self.vkController dismissViewControllerAnimated:YES completion:nil];
                 [SVProgressHUD showErrorWithStatus:error.localizedDescription];
             }];

}

- (void)vkontakteDidFinishLogOut:(Vkontakte *)vkontakte
{
    ALog(@"USER DID LOGOUT");
}

- (void)vkontakteDidFinishGettinUserInfo:(NSDictionary *)info
{
    ALog(@"GOT USER INFO FROM VK: %@", info);
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{
    ALog(@"%@", responce);
}

#pragma mark - FacebookHelperDelegatemethods 

- (void)fbDidLogin:(RestUser *)restUser {
    User *user = [User findOrCreateUserWithRestUser:restUser inManagedObjectContext:self.managedObjectContext];
    self.currentUser = user;
    [RestUser setCurrentUserId:restUser.externalId];
    [RestUser setCurrentUserToken:restUser.authenticationToken];
    [self setIdentifiers:user];
    [SVProgressHUD dismiss];
    [self setupProfile];
}

- (void)fbDidFailLogin:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

- (void)fbSessionValid:(RestUser *)restUser {
    [self fbDidLogin:restUser];
}

- (void)setIdentifiers:(User *)user {
    
    NSString *alias = [NSString stringWithFormat:@"%@", user.externalId];
    [[UAPush shared] setAlias:alias];
    [[UAPush shared] updateRegistration];
    [Flurry setUserID:alias];
    if ([user.gender boolValue]) {
        [Flurry setGender:@"f"];
    } else {
        [Flurry setGender:@"m"];
    }
    if ([user.yearsOld integerValue] > 0) {
        [Flurry setAge:[user.yearsOld integerValue]];
    }

}

- (void)setupProfile {
    AppDelegate *sharedAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [sharedAppDelegate resetWindowToInitialView];

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    
//    BaseNavigationViewController *center = [storyboard instantiateViewControllerWithIdentifier:@"middleViewController"];
//    self.viewDeckController.centerController = center;
//    
//    BaseNavigationViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
//    self.viewDeckController.leftController = menu;
    
}


- (void)viewDidUnload {
    [self setFbLoginButton:nil];
    [super viewDidUnload];
}
@end
