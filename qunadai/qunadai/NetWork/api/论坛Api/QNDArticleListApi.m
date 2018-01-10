//
//  QNDArticleListApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/13.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDArticleListApi.h"

@implementation QNDArticleListApi
{
    NSString * _page;
}

-(instancetype)initWithPage:(NSString*)page{
    self = [super init];
    if (self) {
        _page = page;
    }
    return self;
}


-(NSString*)requestUrl{
    return @"article/query";
}

-(id)requestArgument{
    return @{@"pageNo":_page,@"pageSize": @"10"};
}

@end
