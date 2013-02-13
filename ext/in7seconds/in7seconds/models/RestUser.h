//
//  RestUser.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@interface RestUser : RestObject <RestMappable>

+ (void)create:(NSMutableDictionary *)parameters
        onLoad:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError;



+ (NSNumber *)currentUserId;
+ (void)setCurrentUserId:(NSInteger)userId;
+ (NSString *)currentUserToken;
+ (void)setCurrentUserToken:(NSString *)token;
+ (void)resetIdentifiers;
@end
