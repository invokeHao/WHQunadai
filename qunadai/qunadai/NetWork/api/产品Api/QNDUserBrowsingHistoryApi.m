//
//  QNDUserBrowsingHistoryApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/12.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDUserBrowsingHistoryApi.h"

@implementation QNDUserBrowsingHistoryApi
{
    NSString * _proId;
}
-(instancetype)initWitnProId:(NSString *)proId{
    self = [super init];
    if (self) {
        _proId = proId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"userBrowsingHistory/save";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"productId":_proId};
}

@end
