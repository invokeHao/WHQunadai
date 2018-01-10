//
//  QNDArticleDetailApi.m
//  qunadai
//
//  Created by 王浩 on 2017/12/13.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDArticleDetailApi.h"

@implementation QNDArticleDetailApi
{
    NSString * _articleId;
}
-(instancetype)initWithArticleId:(NSString*)articleId{
    self = [super init];
    if (self) {
        _articleId = articleId;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"article/selectOne";
}

-(id)requestArgument{
    return @{@"id":_articleId};
}

@end
