//
//  CPLProgressView.h
//  qunadai
//
//  Created by wang on 2017/11/2.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

typedef enum : NSUInteger {
    BasicInfoFinish,
    ExtraInfoFinish,
} CPLInfoType;


#import <UIKit/UIKit.h>

@interface CPLProgressView : UIView

-(instancetype)initWithFinishStep:(CPLInfoType)type andFrame:(CGRect)frame;

@end
