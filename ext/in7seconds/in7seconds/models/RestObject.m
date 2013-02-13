//
//  RestObject.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@implementation RestObject

+ (NSError *)customError:(NSError *)error withServerResponse:(NSHTTPURLResponse *)response andJson:(id)JSON {
    NSString *localizedDescription;
    switch (response.statusCode) {
        case kUserNotAuthorized:
            localizedDescription = NSLocalizedString(@"NOT_AUTHORIZED", @"signature incorrect");
            break;
        case kObjectNotFound:
            localizedDescription = NSLocalizedString(@"NOT_FOUND", @"resource not found");
            break;
        case kInternalServerError:
            localizedDescription = NSLocalizedString(@"FATAL_ERROR", @"interal exception");
            break;
        default:
            localizedDescription = [JSON objectForKey:@"message"];
            break;
    }
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setValue:localizedDescription forKey:NSLocalizedDescriptionKey];
    // populate the error object with the details
    NSError *customError = [NSError errorWithDomain:@"Ostronaut" code:response.statusCode userInfo:details];
    [Flurry logError:@"REST_ERROR" message:[JSON objectForKey:@"message"] error:customError];
    return customError;
}
@end
