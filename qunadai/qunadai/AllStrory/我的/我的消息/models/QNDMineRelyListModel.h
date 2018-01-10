//
//  QNDMineRelyListModel.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNDMineRelyListModel : NSObject

@property (copy,nonatomic)NSString * IDS;

@property (copy,nonatomic)NSString * createdTime;

@property (copy,nonatomic)NSString * updatedTime;

@property (copy,nonatomic)NSString * productId;

@property (copy,nonatomic)NSString * commentId;

@property (copy,nonatomic)NSString * userId;

@property (copy,nonatomic)NSString * usernick;

@property (copy,nonatomic)NSString * content;

@property (assign,nonatomic)NSInteger replyNumber;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(CGFloat)cellHeight;


@end
