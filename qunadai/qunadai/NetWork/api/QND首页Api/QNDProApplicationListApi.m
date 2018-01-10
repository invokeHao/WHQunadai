//
//  QNDProApplicationListApi.m
//  qunadai
//
//  Created by wang on 2017/11/15.
//  Copyright © 2017年 Hebei Yulan Investment Management Co.,Ltd. All rights reserved.
//

#import "QNDProApplicationListApi.h"

@implementation QNDProApplicationListApi
{
    int _page ;
}

-(instancetype)initWithPage:(int)page{
    self = [super init];
    if (self) {
        _page = page;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"product/applied";
}

-(id)requestArgument{
    if (KGetACCESSTOKEN&&KGetUserID) {
        return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"pageNo":FORMAT(@"%d",_page)};
    }else{
        return @{@"pageNo":FORMAT(@"%d",_page)};
    }
}

@end
