//
//  QNDMineReplyListApi.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDMineReplyListApi.h"

@implementation QNDMineReplyListApi
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

-(NSString *)requestUrl{
    return @"loan/products/comments/replied";
}

-(id)requestArgument{
    WHLog(@"%@",KGetACCESSTOKEN);
    return @{@"access_token": KGetACCESSTOKEN,@"page":FORMAT(@"%d",_page),@"szie":@"5"};
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

@end
