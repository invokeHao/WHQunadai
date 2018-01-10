//
//  wangUserManager.h
//  qunadai
//
//  Created by wang on 17/4/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wangUserManager : NSObject

/**
 *	@brief	存储密码
 *
 *	@param 	password 	密码内容
 */
+(void)savePassWord:(NSString *)password;

/**
 *	@brief	读取密码
 *
 *	@return	密码内容
 */
+(id)readPassWord;

/**
 *	@brief	删除密码数据
 */
+(void)deletePassWord;

@end
