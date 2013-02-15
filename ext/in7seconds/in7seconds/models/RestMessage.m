//
//  RestMessage.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestMessage.h"

@implementation RestMessage


+ (NSDictionary *)mapping {
    return @{@"id": @"externalId",
             @"message": @"message",
             @"created_at": [NSDate mappingWithKey:@"createdAt" dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"],
             @"is_from_self": @"isFromSelf",
             };
}

+ (void)sendMessageTo:(Match *)user
          withMessage:(NSString *)message
               onLoad:(void (^)(RestMessage *restMessage))onLoad
              onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSDictionary *params = @{@"message[message]": message, @"lite_version": @"true"};
    NSString *path = [NSString stringWithFormat:@"api/v1/users/%@/messages/create_new.json", user.externalId];
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"POST"
                                                                  path:path
                                                            parameters:params];
    
    ALog(@"SendMessage: %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestMessage *restMessage = [RestMessage objectFromJSONObject:JSON mapping:[RestMessage mapping]];
                                                                                                ALog(@"created at is %@", restMessage.createdAt);
                                                                                                dispatch_sync(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(restMessage);
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

+ (void)load:(void (^)(NSSet *messages))onLoad
           onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSString *path = [NSString stringWithFormat:@"api/v1/messages.json"];
    
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"GET"
                                                                  path:path
                                                            parameters:nil];
    ALog(@"load messages: %@", request);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                            
                                                                                            
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                                                                NSMutableSet *messages = [[NSMutableSet alloc] init];
                                                                                                for (id jsonData in JSON) {
                                                                                                    RestMessage *restMessage = [RestMessage objectFromJSONObject:jsonData mapping:[RestMessage mapping]];
                                                                                                    [messages addObject:restMessage];
                                                                                                    
                                                                                                }
                                                                                                onLoad(messages);
                                                                                                
                                                                                            });
                                                                                            
                                                                                            
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSError *customError = [RestObject customError:error withServerResponse:response andJson:JSON];
                                                                                            if (onError)
                                                                                                onError(customError);
                                                                                        }];
    [[RestClient sharedClient] enqueueHTTPRequestOperation:operation];
    
}

@end
