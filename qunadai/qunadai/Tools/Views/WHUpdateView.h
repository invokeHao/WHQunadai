//
//  WHUpdateView.h
//  qunadai
//
//  Created by wang on 2017/10/10.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//
typedef enum : NSUInteger {
    NormalUpdateType,
    ForceUpdateType,
} UpdateType;

#import <UIKit/UIKit.h>

@interface WHUpdateView : UIView

+(void)showTheUpdateViewWithContent:(NSString*)content andType:(UpdateType)type;

@end
