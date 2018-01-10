//
//  QNDBannerBrowseAmount.m
//  qunadai
//
//  Created by 王浩 on 2017/12/18.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDBannerBrowseAmount.h"

@implementation QNDBannerBrowseAmount
{
    NSString * _bannerId;
}


-(instancetype)initWithBannerId:(NSString*)bannerId{
    self = [super init];
    if (self) {
        _bannerId = bannerId;
    }
    return self;
}

-(NSString*)requestUrl{
    return @"banner/browseAmount";
}

-(id)requestArgument{
    return @{@"bannerId":_bannerId};
}


@end
