//
//  VerifyCodeViewController.h
//  qunadai
//
//  Created by wang on 2017/9/6.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDPhoneCodeApi.h"

@interface QNDVerifyCodeViewController : UIViewController

@property (copy,nonatomic)NSString * mobileNumber;//发送短信的手机号

@property (assign,nonatomic)smsApiType apiType;//验证码类型

@end
