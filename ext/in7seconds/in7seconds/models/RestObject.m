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
    ALog(@"error with code %d", response.statusCode);
    switch (response.statusCode) {
        case kUserNotAuthorized:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotAuthorized" object:nil];
            ALog(@"User not authorized!!");
            localizedDescription = NSLocalizedString(@"Ошибка авторизации", @"signature incorrect");
            break;
        case kObjectNotFound:
            localizedDescription = NSLocalizedString(@"Упс. Произошла непредвиденная ошибка (404)", @"resource not found");
            break;
        case kInternalServerError:
            localizedDescription = NSLocalizedString(@"Упс. Произошла непредвиденная ошибка (500)", @"interal exception");
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
