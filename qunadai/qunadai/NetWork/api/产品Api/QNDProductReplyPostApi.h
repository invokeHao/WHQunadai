//
//  QNDProductReplyPostApi.h
//  qunadai
//
//  Created by wang on 2017/9/29.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDProductReplyPostApi : YTKRequest

-(instancetype)initWithReplyId:(NSString *)replyId andContent:(NSString*)content;

@end
