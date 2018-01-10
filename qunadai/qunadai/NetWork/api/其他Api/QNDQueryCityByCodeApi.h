//
//  QNDQueryCityByCodeApi.h
//  qunadai
//
//  Created by 王浩 on 2017/12/18.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDQueryCityByCodeApi : YTKRequest
-(instancetype)initWithParentCode:(NSString*)parentCode;
@end
