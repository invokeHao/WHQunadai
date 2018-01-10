//
//  QNDCPLUserInfoSubmitApi.m
//  qunadai
//
//  Created by wang on 2017/11/9.
//  Copyright © 2017年 Hebei Yulan Investment Management Co.,Ltd. All rights reserved.
//

#import "QNDCPLUserInfoSubmitApi.h"

@implementation QNDCPLUserInfoSubmitApi

{
    CPLUserCreditModel * _model;
}

-(instancetype)initWithModel:(CPLUserCreditModel *)model{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"customer/saveInfo";
}

-(id)requestArgument{
    return @{@"x-auth-token":KGetACCESSTOKEN,@"userId":KGetUserID,@"realName":_model.name,@"idNo":_model.idcard_number,@"mobile":KGetQNDPHONENUM,@"wechatNo":_model.wechat_number,@"qqNo":_model.qq_number,@"education":FORMAT(@"%ld",_model.education_type),@"regionCode":_model.districtCode,@"livingAddress":_model.living_address,@"ifSocialSecurity":FORMAT(@"%ld",_model.shebao_type),@"contactName":_model.contact1_name,@"contactRelationship":FORMAT(@"%ld",_model.contact1_type),@"contactPhone":_model.contact1_cell};
}
@end
