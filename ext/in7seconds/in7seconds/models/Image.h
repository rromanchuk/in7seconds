//
//  Image.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/26/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) User *user;

@end
