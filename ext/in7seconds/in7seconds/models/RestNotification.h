//
//  RestNotification.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/26/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"

@interface RestNotification : RestObject
@property BOOL isRead;
@property (strong, atomic) NSString *message;
@property (strong, atomic) NSString *notificationType;
@property (strong, atomic) NSDate *createdAt;

+ (NSDictionary *)mapping;

@end
