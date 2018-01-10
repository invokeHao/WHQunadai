//
//  PhoneCodeApi.m
//  qunadai
//
//  Created by wang on 17/4/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDPhoneCodeApi.h"

@implementation QNDPhoneCodeApi
{
    NSString * _mobileNumber;
    smsApiType _type;
}

-(instancetype)initWithPhoneNum:(NSString *)phoneNum andType:(smsApiType)type{
    self = [super init];
    if (self) {
        _mobileNumber = phoneNum;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"smsVerifyCode/send";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    WHLog(@"%ld",_type);
    if (_type==smsReset) {
      return  @{@"mobile" : _mobileNumber,@"smsType" : @"forget_pwd"};
    }else if(_type==smsLogin){
        return @{@"mobile": _mobileNumber,@"smsType" : @"login"};
    }else{
        return @{@"mobile": _mobileNumber,@"smsType" : @"register"};
    }
}


@end
