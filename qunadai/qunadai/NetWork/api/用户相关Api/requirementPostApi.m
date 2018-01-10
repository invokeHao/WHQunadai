//
//  requirementPostApi.m
//  qunadai
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "requirementPostApi.h"

@implementation requirementPostApi
{
    NSString * _name;
    NSString * _bankCardNumber;
    NSString * _mobileNumber;
    NSString * _idNumber;
}
-(instancetype)initName:(NSString *)name andBankNum:(NSString *)num andMobileNum:(NSString *)mobile andIdNum:(NSString *)idNum{
    self = [super init];
    if (self) {
        _name = name;
        _bankCardNumber = num;
        _mobileNumber = mobile;
        _idNumber = idNum;
    }
    return self;
}

- (NSString *)requestUrl {
    NSString * url = [NSString stringWithFormat:@"home/requirement?access_token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserToken]];
    return url;
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSDictionary * dic = @{
                            @"name":_name,
                            @"bankCardNumber":_bankCardNumber,
                            @"mobileNumber":_mobileNumber,
                            @"idNumber":_idNumber
                            };
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
