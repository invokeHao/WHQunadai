//
//  QNDPhoneCodeVerifyApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/11.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDPhoneCodeVerifyApi.h"

@implementation QNDPhoneCodeVerifyApi
{
    NSString * _mobileNum;
    NSString * _smsCode;
    smsApiType  _type;
}
-(instancetype)initWithMobileNum:(NSString *)mobileNum andSmsCode:(NSString *)smsCode andSmsType:(smsApiType)type{
    self = [super init];
    if (self) {
        _mobileNum = mobileNum;
        _smsCode = smsCode;
        _type = type;
    }
    return self;
}

-(NSString *)requestUrl{
    return @"smsVerifyCode/validate";
}

-(id)requestArgument{
    NSString * smsStr = @"register";
    if (_type == smsLogin) {
        smsStr = @"login";
    }else if (_type == smsReset){
        smsStr = @"forget_pwd";
    }
    return @{@"mobile":_mobileNum,@"smsType": smsStr,@"verCode": _smsCode, @"agent" : @"Ios",@"deviceId":[[UIDevice currentDevice] identifierForVendor].UUIDString};
}

@end
