//
//  QNDProductCommetListApi.m
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDProductCommetListApi.h"

@implementation QNDProductCommetListApi
{
    NSString * _productId;
    int _page;
}

-(instancetype)initWithProductId:(NSString *)productId andPage:(int)page{
    self = [super init];
    if (self) {
        _productId = productId;
        _page = page;
    }
    return self;
}

-(NSString *)requestUrl{
    return @"product/comment/queryByProductId";
}

-(id)requestArgument{
    return @{@"productId":_productId,@"pageNo":FORMAT(@"%d",_page)};
}


@end
