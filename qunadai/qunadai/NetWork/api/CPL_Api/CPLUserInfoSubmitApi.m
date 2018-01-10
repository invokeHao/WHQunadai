//
//  CPLUserInfoSubmitApi.m
//  qunadai
//
//  Created by wang on 2017/11/1.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLUserInfoSubmitApi.h"

@implementation CPLUserInfoSubmitApi
{
    CPLUserCreditModel * _model;
}

-(instancetype)initWithModel:(CPLUserCreditModel *)model{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"app/credit/basic/submit";
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSDictionary * pramaDic = @{@"app_id": CPLAPPID,@"token": KGetCPLTOKEN,@"city": _model.city,@"contact1_cell": _model.contact1_cell,@"contact1_name":_model.contact1_name,@"contact1_type":[NSNumber numberWithInteger:_model.contact1_type],@"district": _model.district,@"education_type": [NSNumber numberWithInteger:_model.education_type],@"idcard_number": _model.idcard_number,@"living_address": _model.living_address,@"name": _model.name,@"province": _model.province,@"qq_number": _model.qq_number,@"shebao_type": [NSNumber numberWithInteger:_model.shebao_type],@"wechat_number": _model.wechat_number};
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
