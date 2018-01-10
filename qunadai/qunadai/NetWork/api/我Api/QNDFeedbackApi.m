//
//  QNDFeedbackApi.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDFeedbackApi.h"

@implementation QNDFeedbackApi
{
    NSString * _content;
    NSString * _proName;//产品名称
}
-(instancetype)initWitContent:(NSString *)content andProName:(NSString *)proName{
    self = [super init];
    if (self) {
        _content = content;
        _proName = proName;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"feedback/add";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"message":_content,@"pName":_proName};
}
@end
