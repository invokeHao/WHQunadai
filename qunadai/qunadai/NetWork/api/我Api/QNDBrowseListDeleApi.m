//
//  QNDBrowseListDeleApi.m
//  qunadai
//
//  Created by wang on 2017/9/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDBrowseListDeleApi.h"

@implementation QNDBrowseListDeleApi

-(NSString*)requestUrl{
    return @"userBrowsingHistory/clearAll";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN};
}


@end
