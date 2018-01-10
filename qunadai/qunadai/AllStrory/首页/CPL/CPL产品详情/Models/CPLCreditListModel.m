//
//  CPLCreditListModel.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLCreditListModel.h"

@implementation CPLCreditListModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.credit_name = dic[@"credit_name"];
        self.credit_code = dic[@"credit_code"];
        self.credit_status = [self setStatus:dic[@"credit_status"]];
    }
    return self;
}

-(NSInteger)setStatus:(NSString*)str{
    if ([str isKindOfClass:[[NSNull null] class]]) {
        return 0;
    }else{
        return [str integerValue];
    }
}

@end
