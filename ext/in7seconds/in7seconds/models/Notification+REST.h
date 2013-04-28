//
//  Notification+REST.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/26/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Notification.h"
#import "RestNotification.h"
@interface Notification (REST)
+ (Notification *)notificationWithRestNotification:(RestNotification *)restNotification
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
