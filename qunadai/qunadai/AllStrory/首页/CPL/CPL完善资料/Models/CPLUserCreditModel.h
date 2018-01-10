//
//  CPLUserCreditModel.h
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPLUserCreditModel : NSObject

@property (copy,nonatomic) NSString * name;

@property (copy,nonatomic) NSString * idcard_number;

@property (copy,nonatomic) NSString * wechat_number;

@property (copy,nonatomic) NSString * qq_number;

@property (assign,nonatomic) NSInteger  education_type;//受教育程度

@property (assign,nonatomic) NSInteger shebao_type;//社保类型

@property (copy,nonatomic) NSString * province;

@property (copy,nonatomic) NSString * city;

@property (copy,nonatomic) NSString * district;

@property (copy,nonatomic) NSString * living_address;

@property (copy,nonatomic) NSString * contact1_name;

@property (assign,nonatomic) NSInteger contact1_type; //紧急联系人姓名

@property (copy,nonatomic) NSString * contact1_cell;

@property (copy,nonatomic) NSString * districtCode;

-(instancetype)initWithDictionary:(NSDictionary*)dic;



@end
