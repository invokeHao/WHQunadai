//
//  CPLProductModel.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLProductModel.h"
#import "CPLCreditListModel.h"
#import "NSString+extention.h"

@implementation CPLProductModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.prId = dic[@"id"];
        self.name = dic[@"name"];
        self.desc = dic[@"description"];
        self.icon_url = dic[@"icon_url"];
        self.contact_number = dic[@"contact_number"];
        self.requirement = dic[@"requirement"];
        self.result_text = dic[@"result_text"];
        self.application_status = [dic[@"application_status"] integerValue];
        self.application_id = dic[@"application_id"];
        self.application_time = dic[@"application_time"];
        self.min_amount = [dic[@"min_amount"] integerValue];
        self.max_amount = [dic[@"max_amount"] integerValue];
        self.duration_type = [dic[@"duration_type"] integerValue];
        self.min_duration = [dic[@"min_duration"] integerValue];
        self.max_duration = [dic[@"max_duration"] integerValue];
        self.credit_list = [self setupCreditArrWithArr:dic[@"credit_list"]];
        self.applicationType = [self createApplicationType];
    }
    return self;
}

-(NSMutableArray*)setupCreditArrWithArr:(NSArray*)arr{
    NSMutableArray * creditArr= [NSMutableArray arrayWithCapacity:0];
    if ([arr isKindOfClass:[[NSNull null] class]]) {
        return creditArr;
    }
    for (NSDictionary * dic in arr) {
        CPLCreditListModel * model = [[CPLCreditListModel alloc]initWithDictionary:dic];
        [creditArr addObject:model];
    }
    return creditArr;
}

-(CGFloat)textHeight{
    CGFloat textH = [self.requirement sizeWithFont:QNDFont(14) maxSize:CGSizeMake(ViewWidth-24, CGFLOAT_MAX)].height;
    return textH + 30;
}

-(NSMutableArray*)getTheValueData{
    NSMutableArray * dataArr = [NSMutableArray arrayWithCapacity:0];
    NSInteger a = self.min_amount;
    for (NSInteger i = 0 ; i<self.max_amount; i++) {
        if (a>self.max_amount) {
            break;
        }else{
            [dataArr addObject:FORMAT(@"%ld",a)];
            a += 500;
        }
    }
    return dataArr;
}

-(CPLApplicatinType)createApplicationType{
    if (self.application_status==0) {
        return ApplicationSubmit;
    }else if (self.application_status==2){
        return ApplicationReject;
    }else if (self.application_status==3){
        return ApplicationSuccess;
    }else{
        return ApplicationInview;
    }
}

@end
