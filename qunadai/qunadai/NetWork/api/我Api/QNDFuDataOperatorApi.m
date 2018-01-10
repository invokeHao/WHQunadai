//
//  QNDFuDataOperatorApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/15.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDFuDataOperatorApi.h"

@implementation QNDFuDataOperatorApi

-(NSString*)requestUrl{
    return @"fuData/mobile/init";
}

-(id)requestArgument{
    return @{@"mobile":KGetQNDPHONENUM,@"backUrl":FORMAT(@"%@#/fudatabackurl?agent=ios",WYBaseUrl)};
}
@end
