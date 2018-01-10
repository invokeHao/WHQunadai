//
//  QNDCityModel.m
//  qunadai
//
//  Created by 王浩 on 2017/12/18.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDCityModel.h"

@implementation QNDCityModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.IDS = [dic[@"id"] integerValue];
        self.code = dic[@"code"];
        self.name = dic[@"name"];
        self.levelType = [dic[@"levelType"] integerValue];
        self.pinyin = dic[@"pinyin"];
    }
    return self;
}

@end
