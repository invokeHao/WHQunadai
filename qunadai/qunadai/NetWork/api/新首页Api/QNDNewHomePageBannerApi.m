//
//  QNDNewHomePageBannerApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/28.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDNewHomePageBannerApi.h"

@implementation QNDNewHomePageBannerApi
-(NSString*)requestUrl{
    return @"home/page";
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
