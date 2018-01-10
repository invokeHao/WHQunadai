//
//  TopicReplyModel.h
//  qunadai
//
//  Created by wang on 2017/5/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicRRModel.h"


@interface TopicReplyModel : NSObject

@property (copy,nonatomic) NSString * replyId;

@property (copy,nonatomic) NSString * userAvatar;

@property (copy,nonatomic) NSString * userNick;

@property (copy,nonatomic) NSString * createdTime;

@property (copy,nonatomic) NSString * updatedTime;

@property (copy,nonatomic) NSString * replyCount;

@property (assign,nonatomic) NSInteger  thumbUpAmount;

@property (copy,nonatomic) NSString * content;

@property (strong,nonatomic)NSMutableArray * replyArr; //二级回复数据

@property (assign,nonatomic) BOOL praisedByCurrentUser;//当前用户是否点赞

@property (assign,nonatomic)BOOL isAllReply;//是否显示全部评论


-(instancetype)initWithDictionary:(NSDictionary*)dic;


-(CGFloat)replyTableHeight;

-(CGFloat)replyCellHeight;


@end
