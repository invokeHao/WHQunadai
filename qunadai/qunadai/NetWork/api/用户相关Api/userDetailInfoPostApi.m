//
//  userDetailInfoPostApi.m
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "userDetailInfoPostApi.h"

@implementation userDetailInfoPostApi
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
    NSString * url = [NSString stringWithFormat:@"home/creditinfo?access_token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserToken]];
    return url;
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_pramaDic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BaseUrl,self.requestUrl]]];
    WHLog(@"%@",request.URL);
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    return request;
}


@end
