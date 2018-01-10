//
//  QNDProductReplyPostApi.m
//  qunadai
//
//  Created by wang on 2017/9/29.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDProductReplyPostApi.h"

@implementation QNDProductReplyPostApi
{
    NSString * _replyId;
    NSString * _content;
}
-(instancetype)initWithReplyId:(NSString *)replyId andContent:(NSString *)content{
    self = [super init];
    if (self) {
        _replyId = replyId;
        _content = content;
    }
    return  self;
}

-(NSString*)requestUrl{
    WHLog(@"%@",FORMAT(@"loan/products/comments/%@?access_token=%@",_replyId,KGetACCESSTOKEN));
    return FORMAT(@"loan/products/comments/%@?access_token=%@",_replyId,KGetACCESSTOKEN);
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSDictionary * dic = @{@"content":_content};
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
