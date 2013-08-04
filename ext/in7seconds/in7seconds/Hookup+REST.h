//
//  Hookup+REST.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/23/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Hookup.h"
#import "RestHookup.h"
@interface Hookup (REST)
+ (Hookup *)hookupWithRestHookup:(RestHookup *)restHookup
    inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Hookup *)hookupWithExternalId:(NSNumber *)externalId
      inManagedObjectContext:(NSManagedObjectContext *)context;


- (NSString *)fullName;
- (NSNumber *)yearsOld;
- (NSString *)fullLocation;
- (NSString *)vkUrl;
- (NSString *)schoolInfo;
- (NSString *)socialUrl;
@end
