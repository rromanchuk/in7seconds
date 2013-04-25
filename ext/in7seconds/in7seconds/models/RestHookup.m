//
//  RestHookup.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/27/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestHookup.h"
#import "RestUser.h"
#import "RestMutualFriend.h"

static NSString *RESOURCE_PATH = @"users";

@implementation RestHookup


+ (NSDictionary *)mapping {
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"firstName", @"first_name",
                                @"lastName", @"last_name",
                                @"gender", @"gender",
                                @"email", @"email",
                                @"externalId", @"id",
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
                                      dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"], @"created_at",
                                nil];
        
    [map setObject:[RestMutualFriend mappingWithKey:@"mutualFriendObjects" mapping:[RestMutualFriend mapping]] forKey:@"mutual_friend_objects"];
    return map;
}


+ (void)load:(void (^)(NSMutableArray *possibleHookups))onLoad
     onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"GET"
                                                                  path:[RESOURCE_PATH stringByAppendingString:@"/hookups.json"]
                                                            parameters:@{}];
    
    ALog(@"hookups: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                 NSMutableArray *restHookups = [[NSMutableArray alloc] init];
                                                                                                for (id jsonObj in JSON) {
                                                                                                    RestHookup *restHookup = [RestHookup objectFromJSONObject:jsonObj mapping:[RestHookup mapping]];
                                                                                                    [restHookups addObject:restHookup];
                                                                                                }
                                                                                                
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(restHookups);
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
@end
