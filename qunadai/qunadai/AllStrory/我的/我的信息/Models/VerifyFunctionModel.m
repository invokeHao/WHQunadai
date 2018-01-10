//
//  VerifyFunctionModel.m
//  qunadai
//
//  Created by wang on 17/4/5.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "VerifyFunctionModel.h"

@implementation VerifyFunctionModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.iconStr = dic[@"iconStr"];
        self.name = dic[@"name"];
        self.introduct = dic[@"introduct"];
    }
    return self;
}

-(verifyType)type{
    if ([self.statu isEqualToString:@"PROCESSING"]) {
        return  verifingType;
    }else if ([self.statu isEqualToString:@"SUCCESS"]||[self.statu isEqualToString:@"HRISK"]||[self.statu isEqualToString:@"MRISK"]||[self.statu isEqualToString:@"LRISK"]){
        return  verifySuccessType;
    }else if ([self.statu isEqualToString:@"CREATED"]){
        return verifyUndoType;
    }else {
        return verifyFailedType;
    }
}

@end
