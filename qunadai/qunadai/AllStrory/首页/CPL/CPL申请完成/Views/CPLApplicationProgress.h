//
//  CPLApplicationProgress.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLProductModel.h"

@interface CPLApplicationProgress : UIView

-(instancetype)initWithFinishStep:(CPLApplicatinType)type andFrame:(CGRect)frame;


@property (assign,nonatomic)CPLApplicatinType type;


-(void)setType:(CPLApplicatinType)type;

@end
