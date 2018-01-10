//
//  WHScrollLabelView.h
//  qunadai
//
//  Created by wang on 2017/7/20.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHScrollLabelView;
@protocol scrollLabelViewDelegate <NSObject>

- (void)scrollLabelView:(WHScrollLabelView *)scrollLabelView didClickAtIndex:(NSInteger)index;

@end

@interface WHScrollLabelView : UIView
/**
 代理
 */
@property (nonatomic, weak) id<scrollLabelViewDelegate> delegate;
/**
 标题数组
 */
@property (nonatomic, strong) NSArray *titleArray;
/**
 标题字体大小
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 停留时间 默认2s
 */
@property (nonatomic, assign) CGFloat stayInterval;
/**
 滚动动画持续时间 默认0.5s
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;
/// 开始滚动
- (void)beginScrolling;

@end
