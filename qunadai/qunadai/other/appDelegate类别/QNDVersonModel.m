//
//  QNDVersonModel.m
//  qunadai
//
//  Created by 王浩 on 2017/12/13.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDVersonModel.h"

@implementation QNDVersonModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.versionCode = [dic[@"versionCode"] intValue];
        self.versionName = dic[@"versionName"];
        self.appType = dic[@"appType"];
        self.appSize = dic[@"appSize"];
        self.upgradeDescription = dic[@"upgradeDescription"];
        self.upgradeFlag = [dic[@"upgradeFlag"] boolValue];
        self.distribution = [dic[@"distribution"] boolValue];
        self.customerServiceHotline = dic[@"customerServiceHotline"];
        self.bussContact = dic[@"bussContact"] ;
    }
    return self;
}

@end
