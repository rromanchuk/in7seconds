//
//  RestMessage.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestMessage.h"
static NSString *RESOURCE_PATH = @"messages";

@implementation RestMessage


+ (NSDictionary *)mapping {
    return @{@"id": @"externalId",
             @"message": @"message",
             @"created_at": [NSDate mappingWithKey:@"createdAt"
                   dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"],
             @"from_user": [RestUser mappingWithKey:@"fromUser" mapping:[RestUser mapping]],
             @"to_user": [RestUser mappingWithKey:@"toUser" mapping:[RestUser mapping]]};
}

+ (void)sendMessageTo:(User *)user
          withMessage:(NSString *)message
               onLoad:(void (^)(RestMessage *restUser))onLoad
              onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSDictionary *params = @{@"message[message]": message};
    NSString *path = [NSString stringWithFormat:@"users/%@/messages.json", user.externalId];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"POST"
                                                                  path:path
                                                            parameters:params];
    
    ALog(@"SendMessage: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            RestMessage *restMessage = [RestMessage objectFromJSONObject:JSON mapping:[RestMessage mapping]];
                                                                                            if (onLoad)
                                                                                                onLoad(restMessage);
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


+ (void)loadThreadWithUser:(User *)user
                    onLoad:(void (^)(NSArray *messages))onLoad
                   onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSDictionary *params = @{@"user_id": user.externalId};
    NSString *path = [NSString stringWithFormat:@"users/%@/messages.json", user.externalId];

    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"GET"
                                                                  path:path
                                                            parameters:params];
    ALog(@"load thread: %@", request);

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            NSMutableArray *restMessages = [[NSMutableArray alloc] init];
                                                                                            for (id json in JSON) {
                                                                                                ALog(@"in loop with %@", json);
                                                                                                RestMessage *restMessage = [RestMessage objectFromJSONObject:json mapping:[RestMessage mapping]];
                                                                                                ALog(@"restMessage: %@", restMessage);
                                                                                                [restMessages addObject:restMessage];
                                                                                            }
                                                                                
                                                                                            if (onLoad)
                                                                                                onLoad(restMessages);
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
