//
//  userDetailInfoModel.h
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userDetailInfoModel : NSObject


@property (copy,nonatomic) NSString * IDS;

@property (copy,nonatomic) NSString * loanAmount; //借款额度

@property (copy,nonatomic) NSString * loanDeadLine; //借款期限

@property (copy,nonatomic) NSString * employmentStatus;//职业情况

@property (copy,nonatomic) NSString * educationLevel; //学历

@property (copy,nonatomic) NSString * householdIncome; //家庭收入

@property (copy,nonatomic) NSString * maritalStatus;  //婚姻情况

@property (copy,nonatomic) NSString * habitualResidence; //居住地

@property (strong,nonatomic) NSDictionary * paramDic;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(NSDictionary *)paramDic;


@end
