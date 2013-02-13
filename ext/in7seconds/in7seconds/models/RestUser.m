//
//  RestUser.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestUser.h"

static NSString *AUTH_PATH = @"token_authentications.json";

@implementation RestUser
//+ (NSDictionary *)mapping {
//    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                @"firstName", @"first_name",
//                                @"lastName", @"last_name",
//                                //@"fullName", @"full_name",
//                                @"location", @"location",
//                                @"gender", @"sex",
//                                @"email", @"email",
//                                @"externalId", @"id",
//                                //@"checkinsCount", @"checkins_count",
//                                @"authenticationToken", @"authentication_token",
//                                @"fbToken", @"fb_token",
//                                //@"vkToken", @"vk_token"
//                                @"remoteProfilePhotoUrl", @"photo_url",
//                                //@"registrationStatus", @"status",
//                                //@"isNewUserCreated", @"is_new_user_created",
//                                @"isFollowed", @"is_followed",
//                                [NSDate mappingWithKey:@"birthday"
//                                      dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"], @"birthday",
//                                [NSDate mappingWithKey:@"modifiedDate"
//                                      dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"], @"updated_at",
//                                nil];
//    return map;
//}


+ (void)create:(NSMutableDictionary *)parameters
        onLoad:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    
    NSMutableURLRequest *request = [restClient requestWithMethod:@"POST"
                                                             path:AUTH_PATH
                                                       parameters:parameters];
    
    ALog(@"CREATE REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            DLog(@"JSON: %@", JSON);
                                                                                            RestUser *user = [RestUser objectFromJSONObject:JSON mapping:[RestUser mapping]];
                                                                                            if (onLoad)
                                                                                                onLoad(user);
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    [operation start];
}

+ (void)resetIdentifiers {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userAuthenticationToken"];
    [defaults removeObjectForKey:@"currentUser"];
    [defaults removeObjectForKey:@"currentUserId"];
    [defaults synchronize];
}

+ (void)setCurrentUserId:(NSInteger)externalId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:externalId] forKey:@"currentUserId"];
    [defaults synchronize];
}

+ (NSNumber *)currentUserId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"currentUserId"];
}

+ (void)setCurrentUserToken:(NSString *)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"userAuthenticationToken"];
    [defaults synchronize];
}

+ (NSString *)currentUserToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"userAuthenticationToken"];
}

@end
