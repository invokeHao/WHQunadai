//
//  BankVerifyModel.h
//  qunadai
//
//  Created by wang on 2017/4/21.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankVerifyModel : NSObject

//bankCardNumber = 4654654654545313122;
//createdTime = 1492683794000;
//id = "0767b095-b1f5-4924-aa2d-c1f1b45bf9a2";
//idNumber = 320324199402541862;
//mobileNumber = 17854124854;
//name = "\U6653\U660e222";
//updatedTime = 1492684205000;

@property (copy,nonatomic)NSString * IDS;

@property (copy,nonatomic)NSString * bankCardNumber;

@property (copy,nonatomic)NSString * idNumber;

@property (copy,nonatomic)NSString * mobileNumber;

@property (copy,nonatomic)NSString * name;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
