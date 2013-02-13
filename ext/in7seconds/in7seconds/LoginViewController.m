//
//  LoginViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "LoginViewController.h"
#import "RestUser.h"
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapVkLogin:(id)sender {
    if (![[Vkontakte sharedInstance] isAuthorized])
    {
        [[Vkontakte sharedInstance] authenticate];
    }
    else
    {
        [[Vkontakte sharedInstance] logout];
    }

}

#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
    [[Vkontakte sharedInstance] logout];
    [RestUser resetIdentifiers];
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VK_LOGIN_ERROR", @"Error when trying to authenticate vk")];
}

- (void)showVkontakteAuthController:(UIViewController *)controller
{
}

- (void)vkontakteAuthControllerDidCancelled
{
    [RestUser resetIdentifiers];
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Vkontakte sharedInstance].userId, @"user_id", [Vkontakte sharedInstance].accessToken, @"access_token", @"vkontakte", @"platform", nil];
//    if ([Utils NSStringIsValidEmail:[Vkontakte sharedInstance].email]) {
//        [params setValue:[Vkontakte sharedInstance].email forKey:@"email"];
//    }
//    
//    [RestUser create:params
//              onLoad:^(RestUser *restUser) {
//                  if (restUser.isNewUserCreated) {
//                      [Flurry logEvent:@"REGISTRATION_VK_NEW_USER_CREATED"];
//                  } else {
//                      [Flurry logEvent:@"REGISTRATION_VK_EXIST_USER_LOGINED"];
//                  }
//                  restUser.vkToken = [Vkontakte sharedInstance].accessToken;
//                  restUser.vkUserId = [Vkontakte sharedInstance].userId;
//                  restUser.remoteProfilePhotoUrl = [Vkontakte sharedInstance].bigPhotoUrl;
//                  [RestUser setCurrentUserId:restUser.externalId];
//                  [RestUser setCurrentUserToken:restUser.authenticationToken];
//                  [self findOrCreateCurrentUserWithRestUser:restUser];
//                  [self setUASettings];
//                  self.currentUser.vkontakteToken = [Vkontakte sharedInstance].accessToken;
//                  [SVProgressHUD dismiss];
//                  [self didLogIn];
//                  
//              }
//             onError:^(NSError *error) {
//                 [RestUser resetIdentifiers];
//                 [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//             }];

}

- (void)vkontakteDidFinishLogOut:(Vkontakte *)vkontakte
{
    DLog(@"USER DID LOGOUT");
}

- (void)vkontakteDidFinishGettinUserInfo:(NSDictionary *)info
{
    DLog(@"GOT USER INFO FROM VK: %@", info);
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{
    DLog(@"%@", responce);
}

@end
