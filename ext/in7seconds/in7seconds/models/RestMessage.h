//
//  RestMessage.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/8/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"
#import "User+REST.h"

@interface RestMessage : RestObject
@property (strong, atomic) NSString *message;
@property (strong, atomic) RestUser *sender;
@property (strong, atomic) RestUser *receiver;



+ (void)sendMessageTo:(User *)user
          withMessage:(NSString *)message
        onLoad:(void (^)(RestMessage *restUser))onLoad
       onError:(void (^)(NSError *error))onError;

+ (void)loadThreadWithUser:(User *)user
               onLoad:(void (^)(NSArray *messages))onLoad
              onError:(void (^)(NSError *error))onError;


@end