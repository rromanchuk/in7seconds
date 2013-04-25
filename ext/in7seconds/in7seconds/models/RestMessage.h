//
//  RestMessage.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"
#import "User+REST.h"
#import "RestThread.h"
@interface RestMessage : RestObject
@property NSInteger fromUserId;
@property NSInteger toUserId;
@property BOOL isFromSelf;

@property (strong, atomic) NSString *message;
@property (strong, atomic) RestUser *fromUser;
@property (strong, atomic) RestUser *toUser;
@property (strong, atomic) NSDate *createdAt;


+ (NSDictionary *)mapping;

+ (void)sendMessageTo:(User *)user
          withMessage:(NSString *)message
        onLoad:(void (^)(RestThread *restThread))onLoad
       onError:(void (^)(NSError *error))onError;
@end
