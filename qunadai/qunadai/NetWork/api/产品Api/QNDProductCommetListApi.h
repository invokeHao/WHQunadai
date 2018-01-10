//
//  QNDProductCommetListApi.h
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDProductCommetListApi : QNDRequest

-(instancetype)initWithProductId:(NSString *)productId andPage:(int)page;

@end
