//
//  QNDIsMobileNumSetupApi.m
//  qunadai
//
//  Created by wang on 2017/9/5.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDIsMobileNumSetupApi.h"

@implementation QNDIsMobileNumSetupApi
{
    NSString * _mobileNumber;
}

-(instancetype)initWithMobileNumber:(NSString* )mobileNum{
    self = [super init];
    if (self) {
        _mobileNumber = mobileNum;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"checkUser/exists";
}

-(id)requestArgument{
    return @{@"mobile":_mobileNumber};
}


@end
