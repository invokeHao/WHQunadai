//
//  QNDHomePageInfoApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/13.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDHomePageInfoApi.h"

@implementation QNDHomePageInfoApi

-(NSString*)requestUrl{
    return @"home/info";
}

-(id)requestArgument{
    if (KGetACCESSTOKEN&&KGetUserID) {
        return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN};
    }else{
        return nil;
    }
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSData *jsonData = nil;
    if (self.requestArgument) {
       jsonData = [NSJSONSerialization dataWithJSONObject:self.requestArgument options:NSJSONWritingPrettyPrinted error:nil];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BaseUrl,self.requestUrl]]];
    WHLog(@"%@",request.URL);
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (jsonData) {
        [request setHTTPBody:jsonData];
    }
    return request;
}

@end
