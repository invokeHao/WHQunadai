//
//  ValueHomeModel.h
//  qunadai
//
//  Created by wang on 17/3/30.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValueHomeModel : NSObject

/** 新建,处理中,验证成功,验证失败,处理错误,用户被封禁,高风险,中风险,低风险 */
//CREATED, PROCESSING, SUCCESS, FAILURE, ERROR, BANNED, HRISK, MRISK, LRISK

//bankStatus银行认证状态
//realInfoStatus真实信息认证状态
//ebankStatus网银认证状态
//zmxyStatus芝麻信用认证状态
//operatorStatus运营商认证状态
//支付宝认证状态 alipayStatus
//邮箱认证状态 emailStatus
//公积金认证状态 fundStatus
//征信认证状态 zxStatus
//淘宝认证状态 taobaoStatus

@property (assign,nonatomic) NSInteger  loanLimit; //额度

@property (assign,nonatomic) NSInteger loanTotal;//总额度

@property (copy,nonatomic) NSString *  realInfoStatus;// 真实信息

@property (copy,nonatomic) NSString *  bankStatus;// 银行卡验证

@property (copy,nonatomic) NSString * ebankStatus;//网银

@property (copy,nonatomic) NSString * zmxyStatus;//芝麻信用

@property (copy,nonatomic) NSString * operatorStatus;//运营商

@property (copy,nonatomic) NSString * alipayStatus;

@property (copy,nonatomic) NSString * emailStatus;

@property (copy,nonatomic) NSString * fundStatus;

@property (copy,nonatomic) NSString * zxStatus;

@property (copy,nonatomic) NSString * taobaoStatus;


-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
