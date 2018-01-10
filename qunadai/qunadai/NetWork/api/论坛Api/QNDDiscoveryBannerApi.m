//
//  QNDDiscoveryBannerApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/13.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDDiscoveryBannerApi.h"

@implementation QNDDiscoveryBannerApi

-(NSString*)requestUrl{
    return @"banner/discoveryList";
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BaseUrl,self.requestUrl]]];
    WHLog(@"%@",request.URL);
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

@end
