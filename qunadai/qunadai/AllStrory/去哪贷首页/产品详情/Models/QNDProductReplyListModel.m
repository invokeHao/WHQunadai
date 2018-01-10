//
//  QNDProductReplyListModel.m
//  qunadai
//
//  Created by wang on 2017/9/29.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDProductReplyListModel.h"
#import "NSString+extention.h"
#import "WHVerify.h"
//commentId    回复的评论id    string
//content    回复内容    string
//createdTime    回复时间    number
//id    回复id    string
//replyNumber    回复数量    number
//updatedTime    回复更新时间    number
//userId    回复用户id    string
//useravatar    回复用户头像    string
//usernick    回复用户昵称    string

@implementation QNDProductReplyListModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.commentId = dic[@"commentId"];
        self.content = dic[@"content"];
        self.createdTime = dic[@"createdTime"];
        self.updatedTime = dic[@"updatedTime"];
        self.replyId = dic[@"id"];
        self.replyNumber = [dic[@"replyNumber"] integerValue];
        self.userId = dic[@"userId"];
        self.usernick = dic[@"usernick"];
        self.useravatar = [NSString stringWithFormat:@"%@/attachments/%@",BaseUrl,dic[@"useravatar"]];
    }
    return self;
}

-(CGFloat)cell_height{
    CGFloat cellHeight = 0;
    if (self.replyId.length>1) {
        NSString * nameStr = @"";
        if ([WHVerify checkTelNumber:self.usernick]) {
            NSString*bStr = [self.usernick substringWithRange:NSMakeRange(3,4)];
            NSString * phone = [self.usernick stringByReplacingOccurrencesOfString:bStr withString:@"****"];
            nameStr = FORMAT(@"%@：",phone);
        }else{
            nameStr = FORMAT(@"%@：",self.usernick);
        }
        CGFloat replyContentH = [FORMAT(@"%@%@",nameStr,self.content) sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-54-12, MAXFLOAT)].height;
        
        cellHeight += replyContentH + 53;
    }
    return cellHeight;
}

-(NSString *)GetThecreat_time:(NSString*)timestr{
    NSTimeInterval time = [timestr doubleValue]/1000;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    
    NSString * browsingStr = [dateformatter stringFromDate:date];
    
    return browsingStr;
}


@end
