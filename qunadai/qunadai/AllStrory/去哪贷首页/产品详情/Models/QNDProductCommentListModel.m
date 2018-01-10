//
//  QNDProductCommentListModel.m
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDProductCommentListModel.h"
#import "NSString+extention.h"
#import "WHVerify.h"

@implementation QNDProductCommentListModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.content = dic[@"content"];
        self.createdTime = dic[@"createdTime"];
        self.commentId = dic[@"id"];
        self.productId = dic[@"productId"];
        self.stars = [dic[@"stars"] integerValue];
        self.updatedTime = dic[@"updatedTime"];
        self.userId = dic[@"userId"];
        self.useravatar = dic[@"useravatar"];
        self.username = dic[@"username"];
        self.replyNumber = [dic[@"replyNumber"] integerValue];
//        self.replyModel = [[QNDProductReplyListModel alloc]initWithDictionary:dic[@"latestReply"]];
    }
    return self;
}

-(instancetype)initWithModel:(QNDProductCommentListModel *)model{
    self = [super init];
    if (self) {
        self.content = model.content;
        self.createdTime = model.createdTime;
        self.commentId = model.commentId;
        self.productId = model.productId;
        self.stars = model.stars;
        self.updatedTime = model.updatedTime;
        self.userId = model.userId;
        self.username = model.username;
        self.useravatar = model.useravatar;
        self.replyNumber = model.replyNumber;
        self.replyModel = nil;
    }
    return self;
}

-(CGFloat)cellHeight{
    CGFloat cellHeight = 0;
    CGFloat textH = [self.content sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-128, MAXFLOAT)].height;
    cellHeight += textH + 106;
    if (self.content.length<1) {
        cellHeight -= 40;
    }
    if (self.replyModel.replyId.length>1) {
        NSString * nameStr = @"";
        if ([WHVerify checkTelNumber:self.replyModel.usernick]) {
            NSString*bStr = [self.replyModel.usernick substringWithRange:NSMakeRange(3,4)];
            NSString * phone = [self.replyModel.usernick stringByReplacingOccurrencesOfString:bStr withString:@"****"];
            nameStr = FORMAT(@"%@：",phone);
        }else{
            nameStr = FORMAT(@"%@：",self.replyModel.usernick);
        }
        CGFloat textW = [nameStr sizeWithAttributes:@{NSFontAttributeName : QNDFont(14.0)}].width;

        CGFloat replyContentH = [self.replyModel.content sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-54-textW-10-5, MAXFLOAT)].height;
        
//        WHLog(@"%lf",replyContentH);
        if (replyContentH>79) {
            replyContentH = 79;
        }
        cellHeight += replyContentH + 13+14;
    }
    if (self.replyNumber>1&&self.replyModel) {
        cellHeight += 33;
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
