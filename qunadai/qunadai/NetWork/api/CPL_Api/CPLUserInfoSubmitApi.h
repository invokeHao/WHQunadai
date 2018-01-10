//
//  CPLUserInfoSubmitApi.h
//  qunadai
//
//  Created by wang on 2017/11/1.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "CPLUserCreditModel.h"

@interface CPLUserInfoSubmitApi : YTKRequest

-(instancetype)initWithModel:(CPLUserCreditModel*)model;

@end
