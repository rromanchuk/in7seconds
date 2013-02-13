//
//  RestClient.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//
#import "AFHTTPClient.h"

@interface RestClient : AFHTTPClient

+ (RestClient *)sharedClient;
- (NSMutableURLRequest *)signedRequestWithMethod:(NSString *)method
                                            path:(NSString *)path
                                      parameters:(NSDictionary *)_params;
@end


