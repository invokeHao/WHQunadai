//
//  QNDProductCommentListModel.h
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNDProductReplyListModel.h"

@interface QNDProductCommentListModel : NSObject

//"userId": 14,
//"productId": 8,
//"content": "第三个回复",
//"stars": 4,
//"replyNumber": 0,
//"createdTime": 1512445184000,
//"updatedTime": 1512445184000,
//"username": "alsa",
//"userAvatar": "https://ams-sit.qunadai.com:8443/ams/fileView/query?imgType=1&picPath=L2N1c3RvbWVyLzE0LzE0LmpwZw=="


@property (copy,nonatomic) NSString  * content;

@property (copy,nonatomic) NSString  * createdTime;

@property (copy,nonatomic) NSString * updatedTime;

@property (copy,nonatomic) NSString  * commentId;//评论id

@property (copy,nonatomic) NSString * productId; //产品id

@property (assign,nonatomic)NSInteger stars;

@property (copy,nonatomic) NSString  * userId ;//用户id

@property (copy,nonatomic) NSString * useravatar;;//用户头像

@property (copy,nonatomic) NSString * username;//用户昵称

@property (assign,nonatomic)NSInteger replyNumber;

@property (strong,nonatomic)QNDProductReplyListModel * replyModel;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

-(instancetype)initWithModel:(QNDProductCommentListModel*)model;

-(CGFloat)cellHeight;

-(NSString *)GetThecreat_time:(NSString*)timestr;

@end
