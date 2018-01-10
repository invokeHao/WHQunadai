//
//  QNDRequest.h
//  qunadai
//
//  Created by 王浩 on 2018/1/2.
//  Copyright © 2018年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDRequest : YTKRequest

-(instancetype)initWIthUrl:(NSString*)url andParamDic:(NSDictionary*)paramDic;

@end
