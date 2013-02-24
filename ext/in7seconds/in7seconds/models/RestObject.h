//
//  RestObject.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFJSONRequestOperation.h"
#import "RestClient.h"

typedef enum  {
    kObjectNotFound = 404,
    kUserNotAuthorized = 401,
    kInternalServerError = 500
} OstronautNetworkError;


@interface RestObject : NSObject 
@property NSInteger externalId;
+ (NSError *)customError:(NSError *)error withServerResponse:(NSHTTPURLResponse *)response andJson:(id)JSON;
@end

@protocol RestMappable <NSObject>

@required
+ (NSDictionary *)mapping;

@end

@protocol NotAuthorizedDelegate <NSObject>

@required
+ (NSDictionary *)mapping;

@end
