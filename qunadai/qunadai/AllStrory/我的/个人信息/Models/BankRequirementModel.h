//
//  BankRequirementModel.h
//  qunadai
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankRequirementModel : NSObject

@property (copy,nonatomic) NSString * Uid;

@property (copy,nonatomic) NSString * user;

@property (copy,nonatomic) NSString * name;

@property (copy,nonatomic) NSString * bankCardNumber;

@property (copy,nonatomic) NSString *  mobileNumber;

@property (copy,nonatomic) NSString *  idNumber;

@property (copy,nonatomic) NSString * createdTime;

@property (copy,nonatomic) NSString * updatedTime;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
