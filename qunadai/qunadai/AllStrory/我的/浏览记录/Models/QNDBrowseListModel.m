//
//  QNDBrowseListModel.m
//  qunadai
//
//  Created by wang on 2017/9/8.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDBrowseListModel.h"

@implementation QNDBrowseListModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.browsingTime = dic[@"browsingTime"];
        self.ProModel = [[productLoanModel alloc]initWithDictionary:dic[@"productVO"]];
    }
    return self;
}

-(NSString *)getTheBrowsingStr{
    NSTimeInterval time = [self.browsingTime doubleValue]/1000;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];

    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY.MM.dd "];
    
    NSString * browsingStr = [dateformatter stringFromDate:date];
    
    return browsingStr;
}

@end
