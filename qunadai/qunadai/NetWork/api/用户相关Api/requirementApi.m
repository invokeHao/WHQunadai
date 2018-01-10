//
//  requirementApi.m
//  qunadai
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "requirementApi.h"

@implementation requirementApi
{
    NSString * _access_token;
}
-(instancetype)initWithToken:(NSString *)access_token{
    self = [super init];
    if (self) {
        _access_token = access_token;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"home/requirement";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"access_token" : _access_token,
             };
}



@end
