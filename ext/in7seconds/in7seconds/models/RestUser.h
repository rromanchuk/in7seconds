//
//  RestUser.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestObject.h"
#import "User.h"
#import "RestMatch.h"
@interface RestUser : RestObject <RestMappable>

@property NSInteger gender;
@property NSInteger lookingForGender;
@property NSInteger mutualGroups;
@property NSInteger mutualFriendsNum;

// Identifiers
@property (atomic, strong) NSString *authenticationToken;
@property (atomic, strong) NSString *fbToken;
@property (atomic, strong) NSString *vkToken;
@property (atomic, strong) NSString *vkUniversityName;
@property (atomic, strong) NSString *vkGraduation;
@property (atomic, strong) NSString *vkFacultyName;



// Attributes
@property (atomic, strong) NSString *firstName;
@property (atomic, strong) NSString *lastName;
@property (atomic, strong) NSString *groupNames;
@property (atomic, strong) NSString *friendNames;
@property (atomic, strong) NSString *mutualFriendNames;
@property (atomic, strong) NSString *mutualGroupNames;

@property (atomic, strong) NSString *email;
@property (atomic, strong) NSString *photoUrl;
@property (atomic, strong) NSString *city;
@property (atomic, strong) NSString *country;
@property (atomic, strong) NSString *vkDomain;
@property (atomic, strong) NSDate *birthday;
@property (atomic, strong) NSDate *updatedAt;
@property (atomic, strong) NSDate *createdAt;
@property (atomic, strong) NSSet *possibleHookups;
@property (atomic, strong) NSSet *hookups;
@property (atomic, strong) NSSet *mutualFriendObjects;

+ (void)addPhoto:(NSMutableData *)photo
          onLoad:(void (^)(RestUser *restUser))onLoad
         onError:(void (^)(NSError *error))onError;

+ (void)create:(NSMutableDictionary *)parameters
        onLoad:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError;

+ (void)reload:(void (^)(RestUser *restUser))onLoad
       onError:(void (^)(NSError *error))onError;

+ (void)rejectUser:(Hookup *)user
            onLoad:(void (^)(BOOL success))onLoad
           onError:(void (^)(NSError *error))onError;

+ (void)flirtWithUser:(Hookup *)user
               onLoad:(void (^)(RestMatch *restMatch))onLoad
              onError:(void (^)(NSError *error))onError;

+ (void)update:(User *)user
               onLoad:(void (^)(RestUser *restUser))onLoad
              onError:(void (^)(NSError *error))onError;

+ (void)updateProviderToken:(NSString *)token
                forProvider:(NSString *)provider
                        uid:(NSString *)uid
                     onLoad:(void (^)(RestUser *restUser))onLoad
                    onError:(void (^)(NSError *error))onError;

+ (NSDictionary *)mapping;

+ (NSNumber *)currentUserId;
+ (void)setCurrentUserId:(NSInteger)userId;
+ (NSString *)currentUserToken;
+ (void)setCurrentUserToken:(NSString *)token;
+ (void)resetIdentifiers;
@end
