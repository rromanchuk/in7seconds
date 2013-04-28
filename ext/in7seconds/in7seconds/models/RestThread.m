//
//  RestThread.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/24/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestThread.h"
#import "RestMessage.h"
#import "Match+REST.h"
@implementation RestThread
+ (NSDictionary *)mapping {
    return @{@"id": @"externalId",
             @"messages": [RestMessage mappingWithKey:@"messages" mapping:[RestMessage mapping]],
             @"user": [RestUser mappingWithKey:@"user" mapping:[RestUser mapping]],
             @"with_match": [RestMatch mappingWithKey:@"withMatch" mapping:[RestMatch mapping]]
             };

}

+ (void)loadThreadWithUser:(Match *)match
                    onLoad:(void (^)(RestThread *restThread))onLoad
                   onError:(void (^)(NSError *error))onError {
    
    RestClient *restClient = [RestClient sharedClient];
    NSDictionary *params = @{@"user_id": match.externalId};
    NSString *path = [NSString stringWithFormat:@"api/v1/users/%@/messages/thread.json", match.externalId];
    
    NSMutableURLRequest *request = [restClient signedRequestWithMethod:@"GET"
                                                                  path:path
                                                            parameters:params];
    ALog(@"load thread: %@", request);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                                                                            ALog(@"JSON: %@", JSON);
                                                                                    
                                                                                            
                                                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                                RestThread *restThread = [RestThread objectFromJSONObject:JSON mapping:[RestThread mapping]];
                                                                                                                                                                                                
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (onLoad)
                                                                                                        onLoad(restThread);
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

- (NSDictionary *)toDict {
    return @{@"externalId": [NSNumber numberWithInteger:self.externalId], @"messages": self.messages, @"user": self.user, @"withMatch": self.withMatch};
}
@end
