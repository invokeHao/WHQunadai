//
//  QNDMineReplyModel.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNDMineReplyModel : NSObject

@property (copy,nonatomic)NSString * IDS;

@property (copy,nonatomic)NSString * content;

@property (copy,nonatomic)NSString * userId;

@property (copy,nonatomic)NSString * productName;

@property (copy,nonatomic)NSString * productId;

@property (copy,nonatomic)NSString * productIcon;

@property (strong,nonatomic)NSMutableArray * replyList;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(CGFloat)cellHeight;
@end
