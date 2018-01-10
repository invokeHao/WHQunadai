//
//  QNDLocationPostApi.h
//  qunadai
//
//  Created by wang on 2017/12/6.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDLocationPostApi : QNDRequest

-(instancetype)initWithLocationString:(NSString*)location;

@end
