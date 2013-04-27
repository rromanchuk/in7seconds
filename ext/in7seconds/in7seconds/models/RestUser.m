//
//  RestUser.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestUser.h"
#import "Location.h"
#import "RestMutualFriend.h"
static NSString *AUTH_PATH = @"token_authentications.json";
static NSString *RESOURCE_PATH = @"users";
static NSString *RELATIONSHIP_PATH = @"relationships";

@implementation RestUser

+ (NSDictionary *)mapping {
    return [self mapping:NO];
}

+ (NSDictionary *)mapping:(BOOL)is_nested {
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"firstName", @"first_name",
                                @"lastName", @"last_name",
                                @"gender", @"gender",
                                @"lookingForGender", @"looking_for_gender",
                                @"email", @"email",
                                @"externalId", @"id",
                                @"authenticationToken", @"authentication_token",
                                @"fbToken", @"fb_token",
                                @"vkToken", @"vk_token",
                                @"vkUniversityName", @"vk_university_name",
                                @"vkGraduation", @"vk_graduation",
                                @"vkFalcultyName", @"vk_falculty_name",
                                @"photoUrl", @"photo_url",
                                @"mutualFriendsNum", @"mutual_friends_num",
                                @"mutualGroups", @"mutual_groups",
                                @"mutualGroupNames", @"mutual_group_names",
                                @"mutualFriendNames", @"mutual_friend_names",
                                @"groupNames", @"group_names",
                                @"friendNames", @"friend_names",
                                @"city", @"city",
                                @"country", @"country",
                                @"vkDomain", @"vk_domain",
                                [NSDate mappingWithKey:@"birthday"
                                      dateFormatString:@"yyyy-MM-dd"], @"birthday",
                                [NSDate mappingWithKey:@"updatedAt"
                                      dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"], @"updated_at",
                                nil];
    if (!is_nested) {
        [map setObject:[RestUser mappingWithKey:@"possibleHookups" mapping:[RestUser mapping:YES]] forKey:@"possible_hookups"];
        [map setObject:[RestUser mappingWithKey:@"hookups" mapping:[RestUser mapping:YES]] forKey:@"hookups"];
    }
    
    [map setObject:[RestMutualFriend mappingWithKey:@"mutualFriendObjects" mapping:[RestMutualFriend mapping]] forKey:@"mutual_friend_objects"];
    return map;
}

+ (void)addPhoto:(NSMutableData *)photo
        onLoad:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError {

    
    RestClient *restClient = [RestClient sharedClient];

    NSMutableURLRequest *request = [restClient multipartFormRequestWithMethod:@"POST"
                                                                         path:[RESOURCE_PATH stringByAppendingString:@"/images.json"]
                                                                   parameters:@{}
                                                    constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                    {
                                        
                                        [formData appendPartWithFileData:photo
                                                                    name:@"image[image]"
                                                                fileName:@"my_photo.jpg"
                                                                mimeType:@"image/jpeg"];
                                    }];
    
    ALog(@"UPDATE USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            //ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestUser *user = [RestUser objectFromJSONObject:JSON mapping:[RestUser mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(user);
                                                                                                });
                                                                                            });
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

+ (void)updateProviderToken:(NSString *)token
                forProvider:(NSString *)provider
                        uid:(NSString *)uid
                     onLoad:(void (^)(RestUser *restUser))onLoad
                    onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([provider isEqualToString:@"facebook"]) {
        [params setObject:token forKey:@"user[fb_token]"];
    }
    
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"PUT"
                                                                  path:[RESOURCE_PATH stringByAppendingString:@"/update_user.json"]
                                                            parameters:params];
    
    
    
    ALog(@"UPDATE USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            //ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestUser *user = [RestUser objectFromJSONObject:JSON mapping:[RestUser mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(user);
                                                                                                });
                                                                                            });
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


+ (void)update:(User *)user
        onLoad:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError {
    RestClient *restClient = [RestClient sharedClient];
    //ALog(@"got gender:%@ got looking for %@", user.gender, user.lookingForGender);
    NSDictionary *params = @{@"user[looking_for_gender]": user.lookingForGender,
                             @"user[gender]": user.gender,
                             @"user[latitude]": [NSNull nullWhenNil:[Location sharedLocation].latitude],
                             @"user[longitude": [NSNull nullWhenNil:[Location sharedLocation].longitude]
                             };
    
    NSMutableDictionary *p = [params mutableCopy];
    if (user.firstName && user.lastName) {
        [p setObject:user.firstName forKey:@"user[first_name]"];
        [p setObject:user.lastName forKey:@"user[last_name]"];
    }
    
    if (user.email) {
        [p setObject:user.email forKey:@"user[email]"];
    }
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"PUT"
                                                            path:[RESOURCE_PATH stringByAppendingString:@"/update_user.json"]
                                                      parameters:p];
    
   
    
    ALog(@"UPDATE USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            //ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestUser *user = [RestUser objectFromJSONObject:JSON mapping:[RestUser mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(user);
                                                                                                });
                                                                                            });
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
                                                                                            //ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestUser *user = [RestUser objectFromJSONObject:JSON mapping:[RestUser mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(user);
                                                                                                });
                                                                                            });

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


+ (void)reload:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError {
    RestClient *restClient = [RestClient sharedClient];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"GET"
                                                            path:[RESOURCE_PATH stringByAppendingString:@"/authenticated_user.json"]
                                                      parameters:@{}];
    
    ALog(@"RELOAD USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            //ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestUser *user = [RestUser objectFromJSONObject:JSON mapping:[RestUser mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(user);
                                                                                                });
                                                                                            });
                                                                                            
                                                                                            
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

+ (void)rejectUser:(User *)user
            onLoad:(void (^)(BOOL success))onLoad
           onError:(void (^)(NSError *error))onError {
    RestClient *restClient = [RestClient sharedClient];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"POST"
                                                                  path:[RELATIONSHIP_PATH stringByAppendingString:@"/reject.json"]
                                                            parameters:@{@"relationship[hookup_id]": user.externalId}];
    
    ALog(@"REJECT USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            if (onLoad)
                                                                                                onLoad(YES);
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

+ (void)flirtWithUser:(User *)user
               onLoad:(void (^)(RestMatch *restMatch))onLoad
              onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"POST"
                                                                  path:[RELATIONSHIP_PATH stringByAppendingString:@"/flirt.json"]
                                                            parameters:@{@"relationship[hookup_id]": user.externalId}];
    
    ALog(@"REJECT FLIRT REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestMatch *restMatch = [RestMatch objectFromJSONObject:JSON mapping:[RestMatch mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(restMatch);
                                                                                                });
                                                                                            });

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
    [defaults removeObjectForKey:@"authToken"];
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
    [defaults setObject:token forKey:@"authToken"];
    [defaults synchronize];
}

+ (NSString *)currentUserToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"authToken"];
}

- (NSDictionary *)toDict {
    return @{};
}

@end
