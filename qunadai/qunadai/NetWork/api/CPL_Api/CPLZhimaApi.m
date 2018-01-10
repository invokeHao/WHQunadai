//
//  CPLZhimaApi.m
//  qunadai
//
//  Created by wang on 2017/11/9.
//  Copyright © 2017年 Hebei Yulan Investment Management Co.,Ltd. All rights reserved.
//

#import "CPLZhimaApi.h"

@implementation CPLZhimaApi

- (NSString *)requestUrl {
    return @"app/credit/zhima";
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSDictionary * pramaDic = @{@"app_id": CPLAPPID,@"token": KGetCPLTOKEN,@"baseUrl":FORMAT(@"%@#/authentification/zhimafen",WYBaseUrl)};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pramaDic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CPLBaseUrl,self.requestUrl]]];
    WHLog(@"%@",request.URL);
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    return request;
}


@end
