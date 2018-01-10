//
//  QNDBrowseHisListApi.m
//  qunadai
//
//  Created by wang on 2017/9/8.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDBrowseHisListApi.h"

@implementation QNDBrowseHisListApi

-(NSString*)requestUrl{
    return @"userBrowsingHistory/page";
}


-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"pageSize":@"100"};
}


@end
