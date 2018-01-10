//
//  smsRestPasswordApi.m
//  qunadai
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "smsRestPasswordApi.h"

@implementation smsRestPasswordApi
{
    NSString * _mobileNumber;
    NSString * _sha1password;
}


-(instancetype)initWithPhoneNum:(NSString*)phoneNum andPassword:(NSString*)password{
    self = [super init];
    if (self) {
        _mobileNumber = phoneNum;
        _sha1password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"user/resetPassword";
}

- (id)requestArgument {
    return @{
             @"mobile": _mobileNumber,
             @"newPassword" : _sha1password,
             @"x-auth-token": KGetACCESSTOKEN
             };
}

@end
