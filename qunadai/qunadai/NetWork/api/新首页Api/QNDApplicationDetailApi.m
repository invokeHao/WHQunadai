//
//  QNDApplicationDetailApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/29.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDApplicationDetailApi.h"

@implementation QNDApplicationDetailApi
//去哪贷cpl产品申请详情
{
    NSString * _applicationId;
}
-(instancetype)initWithApplicationId:(NSString *)applicationId{
    self = [super init];
    if (self) {
        _applicationId = applicationId;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"applyOrder/query";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"application_id":_applicationId};
}

@end
