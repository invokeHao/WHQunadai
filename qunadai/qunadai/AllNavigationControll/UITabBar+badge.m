//
//  UITabBar+badge.m
//  Yizhenapp
//
//  Created by augbase on 16/8/16.
//  Copyright © 2016年 Augbase. All rights reserved.
//

#import "UITabBar+badge.h"

@implementation UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = QNDRGBColor(239, 99, 37);
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.55) / 4;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.08 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    NSLog(@"%f",badgeView.frame.origin.y);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end
