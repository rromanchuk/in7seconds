//
//  RestUser.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@interface RestUser : RestObject <RestMappable>

@property NSInteger gender;

// Identifiers
@property (atomic, strong) NSString *authenticationToken;
@property (atomic, strong) NSString *fbToken;
@property (atomic, strong) NSString *vkToken;

// Attributes
@property (atomic, strong) NSString *firstName;
@property (atomic, strong) NSString *lastName;
@property (atomic, strong) NSString *email;
@property (atomic, strong) NSString *photoUrl;
@property (atomic, strong) NSString *location;
@property (atomic, strong) NSDate *birthday;
@property (atomic, strong) NSDate *modifiedAt;
@property (atomic, strong) NSDate *createdAt;

+ (void)create:(NSMutableDictionary *)parameters
        onLoad:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError;



+ (NSNumber *)currentUserId;
+ (void)setCurrentUserId:(NSInteger)userId;
+ (NSString *)currentUserToken;
+ (void)setCurrentUserToken:(NSString *)token;
+ (void)resetIdentifiers;
@end
