//
//  Config.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

@property (nonatomic, strong) NSString *vkAppId;
@property (nonatomic, strong) NSString *vkSecretId;
@property (nonatomic, strong) NSString *vkScopes;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong, getter = getVkUrl) NSString *vkUrl;

@property (nonatomic, strong) NSString *airshipKeyDev;
@property (nonatomic, strong) NSString *airshipSecretDev;
@property (nonatomic, strong) NSString *airshipKeyProd;
@property (nonatomic, strong) NSString *airshipSecretProd;
@property (nonatomic, strong) NSString *adHoc;


+ (Config *)sharedConfig;
@end
