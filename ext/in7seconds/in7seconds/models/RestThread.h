//
//  RestThread.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/24/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"
#import "RestUser.h"
#import "RestMatch.h"

@interface RestThread : RestObject

@property (strong, atomic) RestUser *user;
@property (strong, atomic) RestMatch *withMatch;
@property (strong, atomic) NSArray *messages;

+ (NSDictionary *)mapping;

+ (void)loadThreadWithUser:(Match *)match
                    onLoad:(void (^)(RestThread *restThread))onLoad
                   onError:(void (^)(NSError *error))onError;

- (NSDictionary *)toDict;
@end
