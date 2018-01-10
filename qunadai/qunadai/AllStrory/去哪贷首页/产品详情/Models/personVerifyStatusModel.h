//
//  personVerifyStatusModel.h
//  qunadai
//
//  Created by wang on 2017/4/21.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personVerifyStatusModel : NSObject
//"status": "CREATED",
//"bankStatus": "CREATED",
//"realInfoStatus": "CREATED",
//"ebankStatus": "CREATED",
//"zmxyStatus": "CREATED",
//"operatorStatus": "CREATED"

@property (copy,nonatomic) NSString *  realInfoStatus;// 真实信息

@property (copy,nonatomic) NSString *  bankStatus;// 银行卡验证

@property (copy,nonatomic) NSString * ebankStatus;//网银

@property (copy,nonatomic) NSString * zmxyStatus;//芝麻信用

@property (copy,nonatomic) NSString * operatorStatus;//运营商

@property (copy,nonatomic) NSString * status;


-(instancetype)initWithDictionary:(NSDictionary*)dic;


@end
