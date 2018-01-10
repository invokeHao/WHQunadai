//
//  TopicMainModel.m
//  qunadai
//
//  Created by wang on 2017/5/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "TopicMainModel.h"
#import "NSString+extention.h"

@implementation TopicMainModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.IDS = [dic[@"id"] integerValue];
        self.title = dic[@"title"];
        self.titleLogoUrl = dic[@"titleLogoUrl"];
        self.createdTime = dic[@"createdTime"];
        self.browseAmt = [dic[@"browseAmt"] integerValue];
        self.author = dic[@"author"];
        self.articleType = dic[@"articleType"];
        self.createdUser = dic[@"createdUser"];
        self.content = dic[@"content"];
    }
    return self;
}

-(CGFloat)titleCellHeight{
    CGFloat cellHeight = 52;
    CGFloat titleH = [self.title sizeWithFont:QNDFont(16.0) maxSize:CGSizeMake(ViewWidth-48, MAXFLOAT)].height;
    cellHeight += titleH;
    if (cellHeight>95) {
        cellHeight =95;
    }
    return cellHeight;
}

-(CGFloat)detailCellHeight{
    CGFloat cellHeight;
    CGFloat titleH = [self.title sizeWithFont:QNDFont(19.0) maxSize:CGSizeMake(ViewWidth-24, MAXFLOAT)].height;
    if (titleH>44) {
        titleH=44;
    }
    CGFloat contentH = [self.content sizeWithFont:QNDFont(16.0) maxSize:CGSizeMake(ViewWidth-24, MAXFLOAT)].height;
    
    cellHeight = 15+ titleH + contentH + 47 + 80;
    
    return cellHeight;
}


@end
