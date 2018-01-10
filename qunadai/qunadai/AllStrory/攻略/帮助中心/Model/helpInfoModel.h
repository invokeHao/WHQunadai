//
//  helpInfoModel.h
//  qunadai
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface helpInfoModel : NSObject

@property (copy,nonatomic) NSString * IDS;

@property (copy,nonatomic) NSString * question;

@property (copy,nonatomic) NSString * answer;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
