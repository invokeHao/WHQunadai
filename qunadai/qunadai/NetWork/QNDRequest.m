//
//  QNDRequest.m
//  qunadai
//
//  Created by 王浩 on 2018/1/2.
//  Copyright © 2018年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDRequest.h"

@implementation QNDRequest
{
    NSDictionary * _paramDic;
    NSString * _url;
}
-(instancetype)initWIthUrl:(NSString *)url andParamDic:(NSDictionary *)paramDic{
    self = [super init];
    if (self) {
        _paramDic = paramDic;
        _url = url;
    }
    return self;
}

-(NSString *)requestUrl{
    return _url;
}

-(id)requestArgument{
    return _paramDic;
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
