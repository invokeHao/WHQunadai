//
//  helpInfoModel.m
//  qunadai
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "helpInfoModel.h"

@implementation helpInfoModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.IDS = dic[@"id"];
        self.question = dic[@"question"];
        self.answer = dic[@"answer"];
    }
    return self;
}

@end
