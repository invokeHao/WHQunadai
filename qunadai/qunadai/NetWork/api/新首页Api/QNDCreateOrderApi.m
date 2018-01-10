//
//  QNDCreateOrderApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/29.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDCreateOrderApi.h"

@implementation QNDCreateOrderApi
//创建qndCpl订单
{
    NSDictionary * _pramDic;
}
-(instancetype)initWithPramDic:(NSDictionary *)pramDic{
    self = [super init];
    if (self) {
        _pramDic = pramDic;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"applyOrder/create";
}

-(id)requestArgument{
    return _pramDic;
}

@end
