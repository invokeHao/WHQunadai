//
//  TopicRRModel.h
//  qunadai
//
//  Created by wang on 2017/6/5.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicRRModel : NSObject

@property (copy,nonatomic)NSString * IDS;

@property (copy,nonatomic)NSString * content;

@property (copy,nonatomic)NSString * replyName;


@property (assign,nonatomic)CGFloat cellHeight;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(CGFloat)cellHeight;

@end
