//
//  AccountModel.h
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject

@property (copy,nonatomic) NSString * headUrl;
@property (copy,nonatomic) NSString * username;
@property (copy,nonatomic) NSString * mobile;
@property (copy,nonatomic) NSString * mobileAuth; //手机认证状态：1-未认证,2-认证中,3-认证成功,4-认证失败


-(instancetype)initWithDictionary:(NSDictionary * )dic;

-(NSString *)mobileAuth;

@end
