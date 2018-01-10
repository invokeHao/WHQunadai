//
//  QNDCityModel.h
//  qunadai
//
//  Created by 王浩 on 2017/12/18.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNDCityModel : NSObject

@property (assign,nonatomic)NSInteger IDS;

@property (copy,nonatomic)NSString * code;

@property (copy,nonatomic)NSString * name;

@property (assign,nonatomic)NSInteger levelType;//省市区

@property (copy,nonatomic)NSString * pinyin;//拼音

-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
