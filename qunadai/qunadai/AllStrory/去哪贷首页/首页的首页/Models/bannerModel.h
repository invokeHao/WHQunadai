//
//  bannerModel.h
//  qunadai
//
//  Created by wang on 2017/8/3.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bannerModel : NSObject

@property (assign,nonatomic) NSInteger  IDS;

@property (copy,nonatomic) NSString * bannerName;

@property (copy,nonatomic) NSString * bannerPicUrl;

@property (copy,nonatomic) NSString * actionUrl;

@property (copy,nonatomic) NSString * bannerType;

@property (assign,nonatomic) NSInteger displayIndex;

@property (assign,nonatomic) NSInteger browseAmount;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
