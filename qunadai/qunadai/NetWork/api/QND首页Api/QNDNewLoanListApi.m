//
//  QNDNewLoanListApi.m
//  qunadai
//
//  Created by wang on 2017/10/18.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDNewLoanListApi.h"

@implementation QNDNewLoanListApi
{
    int _page;
}
-(instancetype)initWithPage:(int)page{
    self = [super init];
    if (self) {
        _page = page;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"product/latest";
}

-(id)requestArgument{
    if (KGetACCESSTOKEN&&KGetUserID) {
        return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"pageNo":FORMAT(@"%d",_page)};
    }else{
        return @{@"pageNo":FORMAT(@"%d",_page)};
    }
}

@end
