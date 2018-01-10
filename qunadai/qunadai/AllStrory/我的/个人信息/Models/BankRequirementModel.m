//
//  BankRequirementModel.m
//  qunadai
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "BankRequirementModel.h"

@implementation BankRequirementModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.Uid = dic[@"id"];
        self.createdTime = dic[@"createdTime"];
        self.updatedTime = dic[@"updatedTime"];
        self.user = dic[@"user"];
        self.name = dic[@"name"];
        self.bankCardNumber = dic[@"bankCardNumber"];
        self.mobileNumber = dic[@"mobileNumber"];
        self.idNumber = dic[@"idNumber"];
    }
    return self;
}

@end
