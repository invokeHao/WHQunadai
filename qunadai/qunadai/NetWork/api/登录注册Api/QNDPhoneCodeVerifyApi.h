//
//  QNDPhoneCodeVerifyApi.h
//  qunadai
//
//  Created by 王浩 on 2017/12/11.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "QNDPhoneCodeApi.h"

@interface QNDPhoneCodeVerifyApi : QNDRequest
    
-(instancetype)initWithMobileNum:(NSString*)mobileNum andSmsCode:(NSString*)smsCode andSmsType:(smsApiType)type;

@end
