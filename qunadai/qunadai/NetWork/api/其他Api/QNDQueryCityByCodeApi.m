//
//  QNDQueryCityByCodeApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/18.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDQueryCityByCodeApi.h"

@implementation QNDQueryCityByCodeApi
{
    NSString * _parentCode;
}

-(instancetype)initWithParentCode:(NSString*)parentCode{
    self = [super init];
    if (self) {
        _parentCode = parentCode;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"region/queryRegionByPcode";
}

-(id)requestArgument{
    return @{@"parentCode":_parentCode};
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.requestArgument options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BaseUrl,self.requestUrl]]];
    WHLog(@"%@",request.URL);
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    return request;
}


@end
