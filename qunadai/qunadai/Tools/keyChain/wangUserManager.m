//
//  wangUserManager.m
//  qunadai
//
//  Created by wang on 17/4/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "wangUserManager.h"
#import "wangKeyChain.h"

@implementation wangUserManager



static NSString * const KEY_IN_KEYCHAIN = @"com.wang.app.allinfo";
static NSString * const KEY_PASSWORD = @"com.wang.app.password";

+(void)savePassWord:(NSString *)password
{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    [wangKeyChain save:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
}

+(id)readPassWord
{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[wangKeyChain load:KEY_IN_KEYCHAIN];
    return [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
}

+(void)deletePassWord
{
    [wangKeyChain delete:KEY_IN_KEYCHAIN];
}

@end
