//
//  QNDProductPVCollectApi.h
//  qunadai
//
//  Created by 王浩 on 2017/12/12.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

typedef enum : NSUInteger {
    QNDProductType,//去哪贷产品点击量
    QNDApplicateType,//去哪贷产品立即申请点击量
    CPLProductType,
    CPLApplicateType,
    QNDCPLProType,
    QNDCPLApplicateType
} WH_PVType;

@interface QNDProductPVCollectApi : QNDRequest

-(instancetype)initProductCode:(NSString*)proCode andPVType:(WH_PVType)type;

@end
