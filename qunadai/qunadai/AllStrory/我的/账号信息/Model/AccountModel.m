//
//  AccountModel.m
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.headUrl = dic[@"headUrl"];
        self.mobile = dic[@"mobile"];
        self.username = dic[@"username"];
        self.mobileAuth = dic[@"mobileAuth"];
    }
    return self;
}

-(NSString *)mobileAuth{
    NSInteger type = [_mobileAuth integerValue];
    switch (type) {
        case 1:{
            return @"运营商认证 口子随便撸";
            break;}
        case 2:{
            return @" 认证中 ";
            break;}
        case 3:{
            return @" 已认证 ";
            break;}
        case 4:{
            return @"认证失败 请重新认证";
            break;}
        default:
         return @"运营商认证 口子随便撸";
    }
}

@end
