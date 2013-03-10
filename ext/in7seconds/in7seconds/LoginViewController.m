//
//  LoginViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "LoginViewController.h"
#import "RestUser.h"
#import "AppDelegate.h"
#import "UAPush.h"
#import "UAirship.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Vkontakte sharedInstance].delegate = self;
    self.loginLabel.text = NSLocalizedString(@"Войти через Вконтакте", @"Login with vk prompt");
    [[Vkontakte sharedInstance] logout];
	// Do any additional setup after loading the view.
}

- (IBAction)didTapVkLogin:(id)sender {
    ALog(@"did tap");
    if (![[Vkontakte sharedInstance] isAuthorized])
    {
        ALog(@"authenticate");
        [[Vkontakte sharedInstance] authenticate];
    }
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
                  [self saveContext];
                  [RestUser setCurrentUserId:restUser.externalId];
                  [RestUser setCurrentUserToken:restUser.authenticationToken];
                  NSString *alias = [NSString stringWithFormat:@"%d", restUser.externalId];
                  [[UAPush shared] setAlias:alias];
                  [[UAPush shared] updateRegistration];
                  [SVProgressHUD dismiss];
                  [self.delegate didVkLogin:user];
                  [self dismissViewControllerAnimated:YES completion:^(void) {
                      ALog(@"finished dismissing");
                  }];

              }
             onError:^(NSError *error) {
                 [SVProgressHUD dismiss];
                 [RestUser resetIdentifiers];
                 [self dismissViewControllerAnimated:YES completion:nil];
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

@end
