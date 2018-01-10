//
//  bannerModel.m
//  qunadai
//
//  Created by wang on 2017/8/3.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "bannerModel.h"

@implementation bannerModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.IDS = [dic[@"id"] integerValue];
        self.bannerName = dic[@"bannerName"];
        self.bannerPicUrl = dic[@"bannerPicUrl"];
        self.bannerType = dic[@"bannerType"];
        self.actionUrl = dic[@"actionUrl"];
        self.displayIndex = [dic[@"displayIndex"] integerValue];
        self.browseAmount = [dic[@"browseAmount"] integerValue];
    }
    return self;
}

@end
