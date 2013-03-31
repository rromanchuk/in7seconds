//
//  RestMutualFriend.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/31/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "RestMutualFriend.h"

@implementation RestMutualFriend

+ (NSDictionary *)mapping {
    return [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"firstName", @"first_name",
                                       @"lastName", @"last_name",
                                       @"gender", @"gender",
                                       @"lookingForGender", @"looking_for_gender",
                                       @"email", @"email",
                                       @"externalId", @"id",
                                       @"authenticationToken", @"authentication_token",
                                       @"fbToken", @"fb_token",
                                       @"vkToken", @"vk_token",
                                       @"vkUniversityName", @"vk_university_name",
                                       @"vkGraduation", @"vk_graduation",
                                       @"vkFalcultyName", @"vk_falculty_name",
                                       @"photoUrl", @"photo_url",
                                       @"mutualFriendsNum", @"mutual_friends_num",
                                       @"mutualGroups", @"mutual_groups",
                                       @"mutualGroupNames", @"mutual_group_names",
                                       @"mutualFriendNames", @"mutual_friend_names",
                                       @"groupNames", @"group_names",
                                       @"friendNames", @"friend_names",
                                       @"city", @"city",
                                       @"country", @"country",
                                       @"vkDomain", @"vk_domain",
                                       [NSDate mappingWithKey:@"birthday"
                                             dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"], @"birthday",
                                       [NSDate mappingWithKey:@"updatedAt"
                                             dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"], @"updated_at",
                                       nil];

}

@end
