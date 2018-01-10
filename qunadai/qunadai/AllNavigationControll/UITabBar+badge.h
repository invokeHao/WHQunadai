//
//  UITabBar+badge.h
//  Yizhenapp
//
//  Created by augbase on 16/8/16.
//  Copyright © 2016年 Augbase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

-(void)showBadgeOnItemIndex:(int)index;   //显示小红点

-(void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
