//
//  QNDProductPVCollectApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/12.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDProductPVCollectApi.h"

@implementation QNDProductPVCollectApi
{
    NSString * _productCode;
    WH_PVType _type;
}

-(instancetype)initProductCode:(NSString *)proCode andPVType:(WH_PVType)type{
    self = [super init];
    if (self) {
        _productCode = proCode;
        _type = type;
    }
    return self;
}


-(NSString*)requestUrl{
    return @"product/pv/save";
}

-(id)requestArgument{
    if (_type>0) {
        return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"productCode":_productCode,@"pvAgent":@"IOS",@"pvType":FORMAT(@"%ld",_type+1)};
    }else{
        return @{@"productCode":_productCode,@"pvAgent":@"IOS",@"pvType":FORMAT(@"%ld",_type+1)};
    }
}

@end
