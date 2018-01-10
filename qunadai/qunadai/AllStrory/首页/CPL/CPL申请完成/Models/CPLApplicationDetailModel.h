//
//  CPLApplicationDetailModel.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPLApplicationDetailModel : NSObject

@property (copy,nonatomic)NSString * product_id;
@property (copy,nonatomic)NSString * application_id;
@property (copy,nonatomic)NSString * application_time;
@property (assign,nonatomic)NSInteger request_amount;//申请金额
@property (assign,nonatomic)NSInteger duration_number;//还款周期
@property (assign,nonatomic)NSInteger duration_type;
@property (assign,nonatomic)NSInteger application_status;//申请状态
//application_status:  0：未完成； 1: 已提交； 2: 拒绝； 3: 已通过；
@property (copy,nonatomic)NSString * reason;
@property (copy,nonatomic)NSString * url; //跳转的url

@property (copy,nonatomic)NSString * icon_url;//产品头像

@property (copy,nonatomic)NSString * name;//产品名称

@property (copy,nonatomic)NSString * contact_number;//信贷经理电话，qnd产品特有

-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(NSString*)create_durationType;

@end
