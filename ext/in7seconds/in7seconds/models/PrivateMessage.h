//
//  PrivateMessage.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/24/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PrivateMessage : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * isFromSelf;
@property (nonatomic, retain) NSString * message;

@end
