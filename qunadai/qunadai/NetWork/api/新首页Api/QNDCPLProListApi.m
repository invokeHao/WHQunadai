//
//  QNDCPLProList.m
//  qunadai
//
//  Created by 王浩 on 2017/12/28.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDCPLProListApi.h"

@implementation QNDCPLProListApi
//去哪贷自己的cpl列表

-(NSString*)requestUrl{
    return @"product/cpl/list";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN};
}


@end
