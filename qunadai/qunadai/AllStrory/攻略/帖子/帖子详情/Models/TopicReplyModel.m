//
//  TopicReplyModel.m
//  qunadai
//
//  Created by wang on 2017/5/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "TopicReplyModel.h"
#import "NSString+extention.h"

@implementation TopicReplyModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.replyId = dic[@"id"];
        self.content = dic[@"content"];
        self.userNick = dic[@"userNick"];
        self.userAvatar = [NSString stringWithFormat:@"%@/attachments/%@",BaseUrl,dic[@"userAvatar"]];
        self.createdTime = dic[@"createdTime"];
        self.updatedTime = dic[@"updatedTime"];
        self.replyCount = dic[@"replyCount"];
        self.thumbUpAmount = [dic[@"thumbUpAmount"] integerValue];
        self.praisedByCurrentUser = [dic[@"praisedByCurrentUser"] boolValue];
        self.replyArr = [self setUpReplyArrWithArr:dic[@"replyArr"]];
    }
    return self;
}

-(NSMutableArray*)setUpReplyArrWithArr:(NSArray*)sourceArr{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary* dic in sourceArr) {
        TopicRRModel * model = [[TopicRRModel alloc]initWithDictionary:dic];
        [arr addObject:model];
    }
    return arr;
}

-(CGFloat)replyTableHeight{
    
   __block CGFloat tableHeight =0;
    //多于三条回复显示显示三条，并显示查看更多回复
    if (self.replyArr.count>0) {
        [self.replyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TopicRRModel * model = obj;
            tableHeight += model.cellHeight;
            if (idx>1&&!_isAllReply) {
                *stop = YES;
            }
        }];
        tableHeight += 5;
        if (self.replyArr.count>3&&!_isAllReply) {
            tableHeight += 25;
        }
    }
    return tableHeight;
}

-(CGFloat)replyCellHeight{
    
    CGFloat cellHeight;
    CGFloat contentH = [self.content sizeWithFont:QNDFont(16.0) maxSize:CGSizeMake(ViewWidth-40-18, MAXFLOAT)].height;
    cellHeight = contentH + 60;
    
    return cellHeight + [self replyTableHeight]+10;
}


@end
