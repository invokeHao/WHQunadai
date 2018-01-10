//
//  ValueHomeModel.m
//  qunadai
//
//  Created by wang on 17/3/30.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "ValueHomeModel.h"

@implementation ValueHomeModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.loanLimit = [dic[@"valuation"] integerValue];
        self.loanTotal = [dic[@"balance"] integerValue];
        self.bankStatus = dic[@"bankStatus"];
        self.realInfoStatus = dic[@"realInfoStatus"];
        self.ebankStatus = dic[@"ebankStatus"];
        self.zmxyStatus = dic[@"zmxyStatus"];
        self.operatorStatus = dic[@"operatorStatus"];
        self.alipayStatus = dic[@"alipayStatus"];
        self.emailStatus = dic[@"emailStatus"];
        self.fundStatus = dic[@"fundStatus"];
        self.zxStatus = dic[@"zxStatus"];
        self.taobaoStatus = dic[@"taobaoStatus"];
    }
    return self;
}

@end
