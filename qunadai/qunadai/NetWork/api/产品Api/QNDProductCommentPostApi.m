//
//  QNDProductCommentPostApi.m
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDProductCommentPostApi.h"

@implementation QNDProductCommentPostApi
{
    NSString * _productId;
    NSDictionary * _pramaDic;
}

-(instancetype)initWithProductId:(NSString *)productId andPramaDic:(NSDictionary *)pramaDic{
    self = [super init];
    if (self) {
        _productId = productId;
        _pramaDic = pramaDic;
    }
    return self;
}

-(NSString *)requestUrl{
    return FORMAT(@"loan/products/%@/newcomment?access_token=%@",_productId,KGetACCESSTOKEN);
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSDictionary * dic = _pramaDic;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BaseUrl,self.requestUrl]]];
    WHLog(@"%@",request.URL);
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    return request;
}


@end
