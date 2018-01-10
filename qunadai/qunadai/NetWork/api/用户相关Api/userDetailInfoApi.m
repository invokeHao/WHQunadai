//
//  userDetailInfoApi.m
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "userDetailInfoApi.h"

@implementation userDetailInfoApi


- (NSString *)requestUrl {
    return @"home/creditinfo";
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
