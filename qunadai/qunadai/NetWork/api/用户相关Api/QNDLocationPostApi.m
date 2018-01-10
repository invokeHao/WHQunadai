//
//  QNDLocationPostApi.m
//  qunadai
//
//  Created by wang on 2017/12/6.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDLocationPostApi.h"

@implementation QNDLocationPostApi
{
    NSString * _locationStr;
}
-(instancetype)initWithLocationString:(NSString *)location{
    self = [super init];
    if (self) {
        _locationStr = location;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"user/updatePosition";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"position":_locationStr};
}

@end
