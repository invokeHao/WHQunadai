//
//  QNDCPLUserInfoSubmitApi.h
//  qunadai
//
//  Created by wang on 2017/11/9.
//  Copyright © 2017年 Hebei Yulan Investment Management Co.,Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "CPLUserCreditModel.h"

@interface QNDCPLUserInfoSubmitApi : QNDRequest

//CPL里面完善信息后，提交到QND后台PostApi
-(instancetype)initWithModel:(CPLUserCreditModel *)model;

@end
