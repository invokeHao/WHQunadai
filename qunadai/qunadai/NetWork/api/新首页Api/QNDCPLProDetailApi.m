//
//  QNDCPLProDetailApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/29.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDCPLProDetailApi.h"

@implementation QNDCPLProDetailApi
//去哪贷自己的cpl产品详情
{
    NSString * _proCode;
}
-(instancetype)initWithProCode:(NSString *)proCode{
    self = [super init];
    if (self) {
        _proCode = proCode;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"product/cpl/detail";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"productCode":_proCode};
}
@end
