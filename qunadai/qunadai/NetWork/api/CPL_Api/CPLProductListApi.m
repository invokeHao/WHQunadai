//
//  CPLProductListApi.m
//  qunadai
//
//  Created by wang on 2017/11/1.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLProductListApi.h"

@implementation CPLProductListApi

- (NSString *)requestUrl {
    return @"app/product/list";
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSDictionary * pramaDic = @{@"app_id": CPLAPPID,@"token": KGetCPLTOKEN};
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