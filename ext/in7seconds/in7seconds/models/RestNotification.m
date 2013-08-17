//
//  RestNotification.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/26/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestNotification.h"

@implementation RestNotification
+ (NSDictionary *)mapping {
    return @{@"id": @"externalId",
             @"message": @"message",
             @"notification_type": @"notificationType",
             @"is_read": @"isRead",
             @"sender": [RestMatch mappingWithKey:@"sender" mapping:[RestMatch mapping]],
             @"created_at": [NSDate mappingWithKey:@"createdAt"
                                  dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"]
             };
    
}

+ (void)reload:(void (^)(NSArray *notifications))onLoad
       onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSString *path = @"api/v1/notifications.json";
    
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"GET"
                                                                  path:path
                                                            parameters:nil];
    ALog(@"load notifications: %@", request);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            
                                                                                            
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                NSMutableArray *restNotifications = [[NSMutableArray alloc] init];
                                                                                                for (id _restNotification in JSON) {
                                                                                                    RestNotification *restNotification = [RestNotification objectFromJSONObject:_restNotification mapping:[RestNotification mapping]];
                                                                                                    [restNotifications addObject:restNotification];
                                                                                                }
                                                                                                
                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(restNotifications);
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
    [[RestClient sharedClient] enqueueHTTPRequestOperation:operation];
}

+ (void)markAsRead:(void (^)(bool *success))onLoad
       onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSString *path = @"api/v1/notifications/mark_as_read.json";
    
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"POST"
                                                                  path:path
                                                            parameters:nil];
    ALog(@"load notifications: %@", request);
    
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
    [[RestClient sharedClient] enqueueHTTPRequestOperation:operation];
}
@end
