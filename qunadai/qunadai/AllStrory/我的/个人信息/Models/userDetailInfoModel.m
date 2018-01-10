//
//  userDetailInfoModel.m
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "userDetailInfoModel.h"

@implementation userDetailInfoModel

//"loanAmount": "1000",
//"loanDeadLine": "2年",
//"educationLevel": "大专",
//"householdIncome": "1000",
//"employmentStatus": "学生",
//"maritalStatus": "已婚",
//"habitualResidence": "上海浦东新区"


-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.IDS = dic[@"id"];
        self.loanAmount = dic[@"loanAmount"];
        self.loanDeadLine = dic[@"loanDeadLine"];
        self.educationLevel = dic[@"educationLevel"];
        self.householdIncome = dic[@"householdIncome"];
        self.employmentStatus = dic[@"employmentStatus"];
        self.maritalStatus = dic[@"maritalStatus"];
        self.habitualResidence = dic[@"habitualResidence"];
    }
    return self;
}

-(NSDictionary *)paramDic{
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    if ([self verifyTheprama]) {
        return  @{
                  @"loanAmount" : self.loanAmount,
                  @"loanDeadLine" : self.loanDeadLine,
                  @"educationLevel" : self.educationLevel,
                  @"householdIncome" : self.householdIncome,
                  @"employmentStatus" : self.employmentStatus,
                  @"maritalStatus" : self.maritalStatus,
                  @"habitualResidence" : self.habitualResidence
                  };
    }else{
        return nil;
    }
}

-(BOOL)verifyTheprama{
    if (self.loanAmount&&self.loanDeadLine&&self.educationLevel&&self.householdIncome&&self.employmentStatus&&self.maritalStatus&&self.habitualResidence) {
        return YES;
    }else{
        return NO;
    }
}

@end
