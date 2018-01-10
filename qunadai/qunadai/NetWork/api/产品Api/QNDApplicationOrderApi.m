//
//  QNDApplicationOrderApi.m
//  qunadai
//
//  Created by wang on 2017/11/17.
//  Copyright © 2017年 Hebei Yulan Investment Management Co.,Ltd. All rights reserved.
//

#import "QNDApplicationOrderApi.h"

@implementation QNDApplicationOrderApi
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

- (NSString *)requestUrl {
    return @"product/application/save";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"productCode":_proCode};
}

@end
