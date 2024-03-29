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
#import "RestImage.h"
static NSString *AUTH_PATH = @"api/v1/token_authentications.json";
static NSString *RESOURCE_PATH = @"api/v1/users";

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
                                @"emailOptIn", @"email_opt_in",
                                @"pushOptIn", @"push_opt_in",
                                @"email", @"email",
                                @"externalId", @"id",
                                @"authenticationToken", @"authentication_token",
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
                                @"latitude", @"latitude",
                                @"longitude", @"longitude",
                                @"status", @"status",
                                [NSDate mappingWithKey:@"birthday"
                                      dateFormatString:@"yyyy-MM-dd"], @"birthday",
                                [NSDate mappingWithKey:@"updatedAt"
                                      dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"], @"updated_at",
                                nil];
    map[@"mutual_friend_objects"] = [RestMutualFriend mappingWithKey:@"mutualFriendObjects" mapping:[RestMutualFriend mapping]];
    map[@"images"] = [RestImage mappingWithKey:@"images" mapping:[RestImage mapping]];
    return map;
}

+ (void)addPhoto:(NSMutableData *)photo
        onLoad:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError {

    
    RestClient *restClient = [RestClient sharedClient];

    NSMutableURLRequest *request = [restClient multipartFormRequestWithMethod:@"POST"
                                                                         path:@"api/v1/images.json"
                                                                   parameters:nil
                                                    constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                    {
                                        
                                        [formData appendPartWithFileData:photo
                                                                    name:@"image[image]"
                                                                fileName:@"my_photo.jpg"
                                                                mimeType:@"image/jpeg"];
                                    }];
    
    ALog(@"CREATE PHOTO: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
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
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    [[restClient operationQueue] addOperation:operation];
}

+ (void)updateProviderToken:(NSString *)token
                forProvider:(NSString *)provider
                        uid:(NSString *)uid
                     onLoad:(void (^)(RestUser *restUser))onLoad
                    onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([provider isEqualToString:@"facebook"]) {
        params[@"user[fb_token]"] = token;
    }
    
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"PUT"
                                                                  path:[RESOURCE_PATH stringByAppendingString:@"/update_user.json"]
                                                            parameters:params];
    
    
    
    ALog(@"UPDATE USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestUser *user = [RestUser objectFromJSONObject:JSON mapping:[RestUser mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(user);
                                                                                                });
                                                                                            });
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    
    [[restClient operationQueue] addOperation:operation];
}


+ (void)update:(User *)user
        onLoad:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError {
    RestClient *restClient = [RestClient sharedClient];
    //ALog(@"got gender:%@ got looking for %@", user.gender, user.lookingForGender);
    ALog(@"lat: %@ lng: %@", [Location sharedLocation].latitude, [Location sharedLocation].longitude);
    NSDictionary *params = @{@"user[looking_for_gender]": user.lookingForGender,
                             @"user[email_opt_in]": user.emailOptIn,
                             @"user[push_opt_in]": user.pushOptIn,
                             @"user[gender]": user.gender
                             };
    
    NSMutableDictionary *p = [params mutableCopy];
    if (user.email.length > 0) {
        p[@"user[email]"] = user.email;
    }
    
    if (user.birthday) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSString *dateString = [format stringFromDate:user.birthday];
        p[@"user[birthday]"] = dateString;
    }
    
    if ([Location sharedLocation].longitude > 0) {
        p[@"user[latitude]"] = [Location sharedLocation].latitude;
        p[@"user[longitude"] = [Location sharedLocation].longitude;
    }
    if (user.status.length > 0) {
        p[@"user[status]"] = user.status;
    }
    
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"PUT"
                                                            path:[RESOURCE_PATH stringByAppendingString:@"/update_user.json"]
                                                      parameters:p];
    
   
    
    ALog(@"UPDATE USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
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
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    [[restClient operationQueue] addOperation:operation];
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
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    [[restClient operationQueue] addOperation:operation];

}


+ (void)reload:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError {
    RestClient *restClient = [RestClient sharedClient];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"GET"
                                                            path:[RESOURCE_PATH stringByAppendingString:@"/authenticated_user.json"]
                                                      parameters:nil];
    
    ALog(@"RELOAD USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestUser *user = [RestUser objectFromJSONObject:JSON mapping:[RestUser mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(user);
                                                                                                });
                                                                                            });
                                                                                            
                                                                                            
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    [[restClient operationQueue] addOperation:operation];
}

+ (void)rejectUser:(User *)user
            onLoad:(void (^)(BOOL success))onLoad
           onError:(void (^)(NSError *error))onError {
    RestClient *restClient = [RestClient sharedClient];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"POST"
                                                                  path:[RESOURCE_PATH stringByAppendingFormat:@"/%@/reject.json", user.externalId]
                                                            parameters:nil];
    
    ALog(@"REJECT USER REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //ALog(@"JSON: %@", JSON);
                                                                                            if (onLoad)
                                                                                                onLoad(YES);
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    [[restClient operationQueue] addOperation:operation];
}

+ (void)flirtWithUser:(User *)user
               onLoad:(void (^)(RestMatch *restMatch))onLoad
              onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"POST"
                                                                  path:[RESOURCE_PATH stringByAppendingFormat:@"/%@/flirt.json", user.externalId]
                                                            parameters:@{}];
    
    ALog(@"REJECT FLIRT REQUEST: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestMatch *restMatch = [RestMatch objectFromJSONObject:JSON mapping:[RestMatch mapping]];
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(restMatch);
                                                                                                });
                                                                                            });

                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    [[restClient operationQueue] addOperation:operation];
}

+ (void)resetIdentifiers {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"authToken"];
    [defaults removeObjectForKey:@"currentUser"];
    [defaults removeObjectForKey:@"currentUserId"];
    [defaults synchronize];
}

+ (void)setCurrentUserId:(NSNumber *)externalId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:externalId forKey:@"currentUserId"];
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
