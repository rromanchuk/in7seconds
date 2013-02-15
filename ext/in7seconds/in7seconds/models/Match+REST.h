//
//  Match+REST.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/23/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Match.h"
#import "RestMatch.h"
@interface Match (REST)
+ (Match *)matchWithRestMatch:(RestMatch *)restMatch
          inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Match *)matchWithExternalId:(NSNumber *)externalId
        inManagedObjectContext:(NSManagedObjectContext *)context;

- (NSString *)getDistanceFrom:(User *)user;
- (NSString *)fullName;
- (NSNumber *)yearsOld;
- (NSString *)fullLocation;
- (NSString *)vkUrl;
- (NSString *)schoolInfo;
- (NSString *)socialUrl;
@end
