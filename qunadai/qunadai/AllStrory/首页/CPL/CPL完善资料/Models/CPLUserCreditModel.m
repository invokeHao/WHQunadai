//
//  CPLUserCreditModel.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLUserCreditModel.h"
//"name":"张三",
//"idcard_number":"123456789012345678",
//"wechat_number":"12345678910",
//"qq_number":"12345678910",
//"education_type": 1,
//"shebao_type":1,
//"province":"上海",
//"city":"上海",
//"district":"浦东新区",
//"living_address":"*********",
//"contact1_name":"张**",
//"contact1_type": 1,
//"contact1_cell":"12345678910"

@implementation CPLUserCreditModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.idcard_number = dic[@"idcard_number"];
        self.wechat_number = dic[@"wechat_number"];
        self.qq_number = dic[@"qq_number"];
        self.education_type = [dic[@"education_type"] integerValue];
        self.shebao_type = [dic[@"shebao_type"] integerValue];
        self.province = dic[@"province"];
        self.city = dic[@"city"];
        self.district = dic[@"district"];
        self.living_address = dic[@"living_address"];
        self.contact1_name = dic[@"contact1_name"];
        self.contact1_type = [dic[@"contact1_type"] integerValue];
        self.contact1_cell = dic[@"contact1_cell"];
    }
    return self;
}

@end
