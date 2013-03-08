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
             @"message": @"message"};
}

+ (void)sendMessageTo:(User *)user
          withMessage:(NSString *)message
               onLoad:(void (^)(RestMessage *restUser))onLoad
              onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSDictionary *params = @{@"message[message]":message, @"user_id": user.externalId};
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"POST"
                                                                  path:RESOURCE_PATH
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
    
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"GET"
                                                                  path:RESOURCE_PATH
                                                            parameters:params];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            NSArray *restMessages;
                                                                                            //RestMessage *restMessage = [RestMessage objectFromJSONObject:JSON mapping:[RestMessage mapping]];
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
