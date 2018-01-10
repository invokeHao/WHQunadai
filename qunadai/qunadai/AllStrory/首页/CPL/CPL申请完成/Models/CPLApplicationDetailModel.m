//
//  CPLApplicationDetailModel.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLApplicationDetailModel.h"

@implementation CPLApplicationDetailModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.product_id = dic[@"product_id"];
        self.application_id = dic[@"application_id"];
        self.application_time = dic[@"application_time"];
        self.request_amount = [dic[@"request_amount"] integerValue];
        self.duration_number = [dic[@"duration_number"] integerValue];
        self.duration_type = [dic[@"duration_type"] integerValue];
        self.application_status = [dic[@"application_status"] integerValue];
        self.reason = dic[@"reason"];
        self.url = dic[@"url"];
        self.contact_number = dic[@"contact_number"];
    }
    return self;
}

-(NSString *)create_durationType{
    if (self.duration_type == 0) {
        return @"天";
    }
    if (self.duration_type == 1) {
        return @"月";
    }
    else{
        return @"月";
    }
}


@end
