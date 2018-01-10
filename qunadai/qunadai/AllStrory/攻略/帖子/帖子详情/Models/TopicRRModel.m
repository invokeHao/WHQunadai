//
//  TopicRRModel.m
//  qunadai
//
//  Created by wang on 2017/6/5.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "TopicRRModel.h"
#import "NSString+extention.h"

@implementation TopicRRModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.content = dic[@"content"];
        self.IDS = dic[@"id"];
        self.replyName = dic[@"replyName"];
    }
    return self;
}

-(CGFloat)cellHeight{
    
    NSString * contentStr = [NSString stringWithFormat:@"%@：%@",self.replyName,self.content];

    
    CGFloat textHeight = [contentStr sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-83, MAXFLOAT)].height;
    
    return textHeight + 5;
}

@end
