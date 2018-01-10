//
//  CPLCreditListModel.h
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPLCreditListModel : NSObject

@property (copy,nonatomic)NSString * credit_code;//认证类型

@property (copy,nonatomic)NSString * credit_name;//认证名称

@property (assign,nonatomic)NSInteger credit_status;//认证状态 只有为2时认证成功

-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
