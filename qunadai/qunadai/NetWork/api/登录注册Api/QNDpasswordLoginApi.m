//
//  passwordLoginApi.m
//  qunadai
//
//  Created by wang on 17/4/12.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDpasswordLoginApi.h"

@implementation QNDpasswordLoginApi
{
    NSString * _mobileNumber;
    NSString * _password;

}
-(instancetype)initWithPhoneNum:(NSString*)num andPassWord:(NSString*)password{
    self = [super init];
    if (self) {
        _mobileNumber = num;
        _password = password;
    }
    return self;
}
- (NSString *)requestUrl {
    WHLog(@"sha1Password==%@",_password);
    return @"login/usernameAndPassword";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"mobile": _mobileNumber,
             @"password" : _password,
             @"deviceId": [[UIDevice currentDevice]identifierForVendor].UUIDString
            };
}

@end
