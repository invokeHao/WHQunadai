//
//  QNDIsMobileNumSetupApi.h
//  qunadai
//
//  Created by wang on 2017/9/5.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDIsMobileNumSetupApi : QNDRequest

//验证手机号码是否注册过

-(instancetype)initWithMobileNumber:(NSString* )mobileNum;

@end
