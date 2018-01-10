//
//  ModifyInfoApi.m
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "ModifyInfoApi.h"

@implementation ModifyInfoApi
{
    NSString * _nick;
}

-(instancetype)initWithNickName:(NSString*)nick{
    self = [super init];
    if (self) {
        _nick = nick;
    }
    return self;
}

- (NSString *)requestUrl {
//    NSString * encodingString = [_nick stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return @"user/updateUsername";
}

-(id)requestArgument{
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"username":_nick};
}

@end
