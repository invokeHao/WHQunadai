//
//  QNDProductReplyListApi.h
//  qunadai
//
//  Created by wang on 2017/9/29.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDProductReplyListApi : YTKRequest

-(instancetype)initWithCommentId:(NSString*)cId andPage:(int)page;

@end
