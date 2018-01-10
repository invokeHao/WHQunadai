//
//  QNDCPLApplicationListApi.m
//  qunadai
//
//  Created by 王浩 on 2018/1/2.
//  Copyright © 2018年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDCPLApplicationListApi.h"

@implementation QNDCPLApplicationListApi

-(NSString *)requestUrl{
    return @"product/cpl/applied";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN};
}

@end
