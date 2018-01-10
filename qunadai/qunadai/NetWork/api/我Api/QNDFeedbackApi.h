//
//  QNDFeedbackApi.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDFeedbackApi : QNDRequest

//用户反馈PostApi
-(instancetype)initWitContent:(NSString*)content andProName:(NSString*)proName;

@end
