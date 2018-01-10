//
//  WHVerify.h
//  qunadai
//
//  Created by wang on 2017/4/22.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHVerify : NSObject

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;

#pragma 正则银行卡
+ (BOOL)checkBankNum:(NSString*)cardNo;

#pragma 验证N位数字
+(BOOL)checkTheLength:(int)length ofString:(NSString*)numStr;

#pragma 正则用户密码6-18位数组和字母组合
+ (BOOL)checkPass:(NSString*)password;

#pragma QQ号正则
+ (BOOL)checkQQNum:(NSString*)QQ;
#pragma wx号正则
+(BOOL)checkWXNum:(NSString *)WX;

@end
