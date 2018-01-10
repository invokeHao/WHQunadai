//
//  ModifyInfoApi.h
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModifyInfoApi : QNDRequest

//修改昵称PostApi
-(instancetype)initWithNickName:(NSString*)nick;

@end
