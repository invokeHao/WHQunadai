//
//  TopicMainModel.h
//  qunadai
//
//  Created by wang on 2017/5/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicMainModel : NSObject

@property (copy,nonatomic) NSString * titleLogoUrl;//文章标题logo

@property (assign,nonatomic) NSInteger IDS;//帖子id

@property (copy,nonatomic) NSString * title;//标题

@property (copy,nonatomic) NSString * author;//作者

@property (copy,nonatomic) NSString * content;

@property (copy,nonatomic) NSString * articleType;//文章类型:1-攻略,2-帖子

@property (assign,nonatomic) NSInteger browseAmt;//浏览量

@property (copy,nonatomic) NSString * createdUser;//创建人

@property (copy,nonatomic) NSString * createdTime;//创建时间


-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(CGFloat)titleCellHeight;//帖子列表高度

-(CGFloat)detailCellHeight;//帖子详情高度

@end
