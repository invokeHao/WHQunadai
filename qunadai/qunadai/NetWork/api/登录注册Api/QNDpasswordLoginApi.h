//
//  passwordLoginApi.h
//  qunadai
//
//  Created by wang on 17/4/12.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNDpasswordLoginApi : QNDRequest

//密码登录api
-(instancetype)initWithPhoneNum:(NSString*)num andPassWord:(NSString*)password;

@end
