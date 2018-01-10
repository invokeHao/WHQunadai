//
//  QNDUserCountInfoApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/11.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDUserCountInfoApi.h"

@implementation QNDUserCountInfoApi

-(NSString*)requestUrl{
    return @"user/selectOne";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN};
}

@end
