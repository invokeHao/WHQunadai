//
//  QNDMineReplyModel.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDMineReplyModel.h"
#import "QNDMineRelyListModel.h"

#import "NSString+extention.h"

@implementation QNDMineReplyModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.IDS = dic[@"id"];
        self.productId = dic[@"productId"];
        self.productIcon = [NSString stringWithFormat:@"%@/attachments/%@",BaseUrl,dic[@"productIcon"]];
        self.productName = dic[@"productName"];
        self.userId = dic[@"userId"];
        self.content = dic[@"content"];
        self.replyList = [self setupArrWithArr:dic[@"replies"]];
    }
    return self;
}

-(NSMutableArray*)setupArrWithArr:(NSArray*)arr{
    NSMutableArray * resultArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in arr) {
        QNDMineRelyListModel * model = [[QNDMineRelyListModel alloc]initWithDictionary:dic];
        [resultArr addObject:model];
    }
    return resultArr;
}

-(CGFloat)cellHeight{
    CGFloat cellHeight = 10+70+15+10;
    CGFloat textH = [self.content sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-70, MAXFLOAT)].height;
    
    cellHeight += textH + 10;
    
    for (QNDMineRelyListModel * model in self.replyList) {
        cellHeight += [model cellHeight];
    }
    return cellHeight;
}
@end
