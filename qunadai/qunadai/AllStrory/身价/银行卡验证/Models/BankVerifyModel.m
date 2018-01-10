//
//  BankVerifyModel.m
//  qunadai
//
//  Created by wang on 2017/4/21.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "BankVerifyModel.h"

//bankCardNumber = 4654654654545313122;
//createdTime = 1492683794000;
//id = "0767b095-b1f5-4924-aa2d-c1f1b45bf9a2";
//idNumber = 320324199402541862;
//mobileNumber = 17854124854;
//name = "\U6653\U660e222";
//updatedTime = 1492684205000;


@implementation BankVerifyModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.IDS = dic[@"id"];
        self.idNumber = dic[@"idNumber"];
        self.mobileNumber = dic[@"mobileNumber"];
        self.name = dic[@"name"];
        self.bankCardNumber = dic[@"bankCardNumber"];
    }
    return self;
}


@end
