//
//  RestNotification.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/26/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"
#import "RestMatch.h"
@interface RestNotification : RestObject
@property BOOL isRead;
@property (strong, atomic) NSString *message;
@property (strong, atomic) NSString *notificationType;
@property (strong, atomic) NSDate *createdAt;
@property (strong, atomic) RestMatch *sender;

+ (NSDictionary *)mapping;
+ (void)reload:(void (^)(NSArray *notifications))onLoad
       onError:(void (^)(NSError *error))onError;
+ (void)markAsRead:(void (^)(BOOL success))onLoad
           onError:(void (^)(NSError *error))onError;
@end
