//
//  FacebookHelper.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//


#import "Facebook.h"
#import "RestUser.h"
@protocol FacebookHelperDelegate;

@interface FacebookHelper : NSObject <FBRequestDelegate>

@property (weak, nonatomic) id <FacebookHelperDelegate> delegate;
@property (strong, nonatomic) Facebook *facebook;

- (void)login;
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error;

- (void)uploadPhotoToFacebook:(UIImage *)image withMessage:(NSString *)message;
- (BOOL)canPublishActions;
- (void)prepareForPublishing;
- (void)syncAccount;
+ (FacebookHelper *)shared;


@end

@protocol FacebookHelperDelegate <NSObject>

@required
- (void)fbDidLogin:(RestUser *)restUser;
- (void)fbDidFailLogin:(NSError *)error;
- (void)fbSessionValid:(RestUser *)restUser;
@end