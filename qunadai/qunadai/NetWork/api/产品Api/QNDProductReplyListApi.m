//
//  QNDProductReplyListApi.m
//  qunadai
//
//  Created by wang on 2017/9/29.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDProductReplyListApi.h"

@implementation QNDProductReplyListApi
{
    NSString * _cId;
    int  _page;
}
-(instancetype)initWithCommentId:(NSString *)cId andPage:(int)page{
    self = [super init];
    if (self) {
        _cId = cId;
        _page = page;
    }
    return self;
}

-(id)requestArgument{
    return @{@"page":FORMAT(@"%d",_page),@"szie":@"10"};
}


-(NSString*)requestUrl{
    return FORMAT(@"loan/products/comments/%@/replies",_cId);
}


@end
