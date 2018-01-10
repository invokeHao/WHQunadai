//
//  QNDProductCommentPostApi.h
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDProductCommentPostApi : YTKRequest

-(instancetype)initWithProductId:(NSString*)productId andPramaDic:(NSDictionary*)pramaDic;

@end
