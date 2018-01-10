//
//  QNDMineRelyListModel.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDMineRelyListModel.h"
#import "NSString+extention.h"

#import "WHVerify.h"

@implementation QNDMineRelyListModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.IDS = dic[@"id"];
        self.createdTime = dic[@"createdTime"];
        self.updatedTime = dic[@"updatedTime"];
        self.productId = dic[@"productId"];
        self.commentId = dic[@"commentId"];
        self.userId = dic[@"usrId"];
        self.usernick = dic[@"usernick"];
        self.content = dic[@"content"];
        self.replyNumber = [dic[@"replyNumber"] integerValue];
    }
    return self;
}

-(CGFloat)cellHeight{
    CGFloat cellHeight = 15;
    NSString * nickStr = @"";
    if ([WHVerify checkTelNumber:self.usernick]) {
        NSString*bStr = [self.usernick substringWithRange:NSMakeRange(3,4)];
        NSString * phone = [self.usernick stringByReplacingOccurrencesOfString:bStr withString:@"****"];
        nickStr = FORMAT(@"%@：",phone);
    }else{
        nickStr = FORMAT(@"%@：",self.usernick);
    }
    NSString * MStr = FORMAT(@"%@%@",nickStr,self.content);
    
    CGFloat textH = [MStr sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-50, MAXFLOAT)].height;
    cellHeight += textH;
    return cellHeight;
    
}

@end
