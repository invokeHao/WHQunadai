//
//  smsRestPasswordApi.h
//  qunadai
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface smsRestPasswordApi : QNDRequest

//重置密码api
-(instancetype)initWithPhoneNum:(NSString*)phoneNum andPassword:(NSString*)password;

@end
