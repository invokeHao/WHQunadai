//
//  QNDVersonModel.h
//  qunadai
//
//  Created by 王浩 on 2017/12/13.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNDVersonModel : NSObject

@property (assign,nonatomic)int versionCode; //版本号

@property (copy,nonatomic) NSString * versionName;//版本名称

@property (copy,nonatomic) NSString * appType;//平台

@property (copy,nonatomic) NSString * appSize;//大小

@property (copy,nonatomic) NSString * upgradeDescription;//更新描述

@property (assign,nonatomic) BOOL upgradeFlag;//是否强制更新

@property (assign,nonatomic) BOOL distribution;//是否上线

@property (copy,nonatomic) NSString * customerServiceHotline;//客服电话

@property (copy,nonatomic) NSString * bussContact;//邮箱

-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
