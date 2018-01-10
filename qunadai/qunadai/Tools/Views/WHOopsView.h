//
//  WHOopsView.h
//  qunadai
//
//  Created by wang on 2017/10/11.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//
typedef void(^doneBlock)();

#import <UIKit/UIKit.h>

@interface WHOopsView : UIView

+(instancetype)shareInstance;

-(void)showTheOopsViewOneTheView:(UIView*)view WithDoneBlock:(doneBlock)doneblcok;

-(void)hidenTheOops;

@end
