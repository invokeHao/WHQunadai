//
//  QNDProUnappliedListApi.h
//  qunadai
//
//  Created by wang on 2017/11/15.
//  Copyright © 2017年 Hebei Yulan Investment Management Co.,Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDProUnappliedListApi : QNDRequest

//未申请列表
-(instancetype)initWithPage:(int)page;

@end
