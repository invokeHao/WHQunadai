//
//  VerifyFunctionModel.h
//  qunadai
//
//  Created by wang on 17/4/5.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

typedef enum : NSUInteger {
    verifySuccessType,
    verifingType,
    verifyUndoType,
    verifyFailedType
} verifyType;

#import <Foundation/Foundation.h>

@interface VerifyFunctionModel : NSObject

@property (copy,nonatomic) NSString * iconStr;

@property (copy,nonatomic) NSString * name;

@property (copy,nonatomic) NSString * introduct;

@property (copy,nonatomic) NSString * statu;//状态

@property (assign,nonatomic) verifyType  type;//认证状态


-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(verifyType)type;

@end
