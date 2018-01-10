//
//  PensonVerifyStatusApi.m
//  qunadai
//
//  Created by wang on 2017/4/21.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "PensonVerifyStatusApi.h"

@implementation PensonVerifyStatusApi

- (NSString *)requestUrl {
    return @"home/getUserPersonalValue";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"access_token" : [[NSUserDefaults standardUserDefaults] objectForKey:KUserToken],
             };
}


@end
