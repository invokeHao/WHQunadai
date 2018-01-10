//
//  CPLLonginApi.m
//  qunadai
//
//  Created by wang on 2017/10/31.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLLonginApi.h"

@implementation CPLLonginApi
{
    NSDictionary * _pramaDic;
}

-(instancetype)initWithparamDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _pramaDic = dic;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"app/reqToken";
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_pramaDic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CPLBaseUrl,self.requestUrl]]];
    WHLog(@"%@",request.URL);
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    return request;
}

@end
