//
//  QNDProductReplyListModel.h
//  qunadai
//
//  Created by wang on 2017/9/29.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNDProductReplyListModel : NSObject

@property (copy,nonatomic) NSString * commentId;
@property (copy,nonatomic) NSString * content;
@property (copy,nonatomic) NSString * createdTime;
@property (copy,nonatomic) NSString * updatedTime;
@property (copy,nonatomic) NSString * replyId;
@property (copy,nonatomic) NSString * userId;
@property (copy,nonatomic) NSString * useravatar;
@property (copy,nonatomic) NSString * usernick;
@property (assign,nonatomic)NSInteger replyNumber;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(CGFloat)cell_height;

-(NSString *)GetThecreat_time:(NSString*)timestr;
@end
