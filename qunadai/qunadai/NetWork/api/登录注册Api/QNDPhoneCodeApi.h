//
//  PhoneCodeApi.h
//  qunadai
//
//  Created by wang on 17/4/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

typedef enum : NSUInteger {
    smsSetup,
    smsLogin,
    smsReset
} smsApiType;

#import <Foundation/Foundation.h>

@interface QNDPhoneCodeApi : QNDRequest

//获取验证码api
-(instancetype)initWithPhoneNum:(NSString*)phoneNum andType:(smsApiType)type;


@end
