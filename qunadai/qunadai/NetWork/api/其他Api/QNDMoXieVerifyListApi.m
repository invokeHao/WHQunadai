//
//  QNDMoXieVerifyListApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/20.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDMoXieVerifyListApi.h"

@implementation QNDMoXieVerifyListApi

-(NSString*)requestUrl{
    return @"user/personalValue";
}

-(id)requestArgument{
    return @{@"x-auth-token":KGetACCESSTOKEN,@"mobile":KGetQNDPHONENUM};
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
