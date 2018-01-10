//
//  WHSegmentedControl.h
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WHSegmentedControlDelegate <NSObject>

@required
//代理函数 获取当前下标
- (void)WHSegmentedControlSelectAtIndex:(NSInteger)index;

@end

@interface WHSegmentedControl : UIView

@property (assign, nonatomic) id<WHSegmentedControlDelegate>delegate;
//初始化函数
- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate andImageArry:(NSArray*)imageArry andSelectImageArry:(NSArray*)selectImageArray;

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate;

//提供方法改变 index
- (void)changeSegmentedControlWithIndex:(NSInteger)index;

@end
