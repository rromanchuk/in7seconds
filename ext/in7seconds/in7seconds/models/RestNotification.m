//
//  RestNotification.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/26/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestNotification.h"

@implementation RestNotification
+ (NSDictionary *)mapping {
    return @{@"id": @"externalId",
             @"message": @"message",
             @"notification_type": @"notificationType",
             @"is_read": @"isRead",
             @"created_at": [NSDate mappingWithKey:@"createdAt"
                                  dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"]
             };
    
}
@end
