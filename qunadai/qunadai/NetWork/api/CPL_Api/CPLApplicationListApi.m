//
//  CPLApplicationListApi.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLApplicationListApi.h"

@implementation CPLApplicationListApi

//已申请产品列表

- (NSString *)requestUrl {
    return @"app/product/applications";
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSDictionary * pramaDic = @{@"app_id": CPLAPPID,@"token": KGetCPLTOKEN};
    WHLog(@"%@",pramaDic);
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
