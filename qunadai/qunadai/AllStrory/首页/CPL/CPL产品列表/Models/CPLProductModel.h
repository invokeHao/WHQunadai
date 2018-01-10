//
//  CPLProductModel.h
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ApplicationSubmit,
    ApplicationInview,
    ApplicationReject,
    ApplicationSuccess
} CPLApplicatinType;


@interface CPLProductModel : NSObject

@property (copy,nonatomic)NSString * prId;

@property (copy,nonatomic)NSString * name;

@property (copy,nonatomic)NSString * desc;

@property (copy,nonatomic)NSString * icon_url;

@property (copy,nonatomic)NSString * contact_number;

@property (copy,nonatomic)NSString * requirement;

@property (assign,nonatomic)NSInteger application_status;//申请状态

@property (copy,nonatomic)NSString * application_id;
@property (copy,nonatomic)NSString * application_time;


@property (copy,nonatomic)NSString * result_text; //申请状态

@property (assign,nonatomic)NSInteger min_amount;

@property (assign,nonatomic)NSInteger max_amount;

@property (assign,nonatomic)NSInteger duration_type;

@property (assign,nonatomic)NSInteger min_duration;//最小还款周期

@property (assign,nonatomic)NSInteger max_duration;//最大还款周期

@property (strong,nonatomic)NSMutableArray * credit_list;//认证列表

@property (assign,nonatomic)CPLApplicatinType applicationType;//申请状态

@property (assign,nonatomic)BOOL isQND;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(CGFloat)textHeight;

-(NSMutableArray*)getTheValueData;

-(CPLApplicatinType)applicationType;
@end
