//
//  Config.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 2/13/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Config.h"

@implementation Config
- (id)init
{
    self = [super init];
    
    if (self) {
        NSString *configuration    = [[NSBundle mainBundle] infoDictionary][@"Configuration"];
        NSBundle *bundle           = [NSBundle mainBundle];
        NSDictionary *environments = [[NSDictionary alloc] initWithContentsOfFile:[bundle pathForResource:@"environments" ofType:@"plist"]];
        NSDictionary *environment  = environments[configuration];
        self.vkAppId = [environment valueForKey:@"vkAppId"];
        self.vkSecretId = [environment valueForKey:@"vkSecretId"];
        self.vkScopes = [environment valueForKey:@"vkScopes"];
        self.fbScopes = [[environment valueForKey:@"fbScopes"] componentsSeparatedByString:@","];
        
        self.baseURL = [environment valueForKey:@"baseURL"];
        
        self.airshipSecretProd = [environment valueForKey:@"PRODUCTION_APP_SECRET"];
        self.airshipKeyProd = [environment valueForKey:@"PRODUCTION_APP_KEY"];
        
        
        self.airshipSecretDev = [environment valueForKey:@"DEVELOPMENT_APP_SECRET"];
        self.airshipKeyDev = [environment valueForKey:@"DEVELOPMENT_APP_KEY"];
        self.adHoc = [environment valueForKey:@"APP_STORE_OR_AD_HOC_BUILD"];
    }
    
    return self;
}

- (NSString *)getVkUrl {
    NSString *url = [NSString stringWithFormat:@"http://oauth.vk.com/authorize?client_id=%@&scope=%@&redirect_uri=http://oauth.vk.com/blank.html&display=touch&response_type=token", self.vkAppId, self.vkScopes];
    return url;
}


+ (Config *)sharedConfig
{
    static dispatch_once_t pred;
    static Config *sharedConfig;
    
    dispatch_once(&pred, ^{
        sharedConfig = [[Config alloc] init];
    });
    
    return sharedConfig;
}

@end
