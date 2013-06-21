//
//  RestClient.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestClient.h"
#import "Config.h"
#import "RestUser.h"

@implementation RestClient

+ (RestClient *)sharedClient
{
    static dispatch_once_t pred;
    static RestClient *_sharedClient;
    
    dispatch_once(&pred, ^{
        _sharedClient = [[RestClient alloc] initWithBaseURL:[NSURL URLWithString:[Config sharedConfig].baseURL]];
    });
    
    return _sharedClient;
}


- (NSMutableURLRequest *)signedRequestWithMethod:(NSString *)method
                                            path:(NSString *)path
                                      parameters:(NSDictionary *)_params {
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (_params != nil) {
        [parameters addEntriesFromDictionary:_params];
    }
    
    [parameters setValue:[RestUser currentUserToken] forKey:@"auth_token"];
    NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    return request;
    
}


@end
