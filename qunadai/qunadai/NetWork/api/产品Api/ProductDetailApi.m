//
//  ProductDetailApi.m
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "ProductDetailApi.h"

@implementation ProductDetailApi
{
    NSString * _productCode;
}

-(instancetype)initWithProductCode:(NSString *)productCode{
    self = [super init];
    if (self) {
        _productCode = productCode;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"product/queryByCode";
}

-(id)requestArgument{
    return @{@"productCode":_productCode,@"pvAgent":@"IOS"};
}



@end
