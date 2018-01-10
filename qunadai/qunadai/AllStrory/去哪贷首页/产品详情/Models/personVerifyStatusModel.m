//
//  personVerifyStatusModel.m
//  qunadai
//
//  Created by wang on 2017/4/21.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "personVerifyStatusModel.h"

@implementation personVerifyStatusModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.bankStatus = dic[@"bankStatus"];
        self.realInfoStatus = dic[@"realInfoStatus"];
        self.ebankStatus = dic[@"ebankStatus"];
        self.zmxyStatus = dic[@"zmxyStatus"];
        self.operatorStatus = dic[@"operatorStatus"];
        self.status = dic[@"status"];
    }
    return self;
}

@end
