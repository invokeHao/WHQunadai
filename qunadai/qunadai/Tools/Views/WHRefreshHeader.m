//
//  WHRefreshHeader.m
//  qunadai
//
//  Created by wang on 2017/4/20.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "WHRefreshHeader.h"

@interface WHRefreshHeader()

@property(weak, nonatomic) UIView * headerFreshView;
@property(weak, nonatomic)UILabel * label;
@property (strong,nonatomic) UIImageView * loadingImageV;
@property(nonatomic, strong)UIImageView * imageView;

@end

@implementation WHRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 75;
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    self.headerFreshView = view;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = QNDAssistText153Color;
    label.font = QNDFont(12.0);
    label.textAlignment = NSTextAlignmentCenter;
    [self.headerFreshView addSubview:label];
    self.label = label;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"refresh_bg"];
    [self.headerFreshView addSubview:imageView];
    self.imageView = imageView;
    
    UIImageView * loadView = [[UIImageView alloc]init];
    loadView.image = [UIImage imageNamed:@"refresh"];
    [self.headerFreshView addSubview:loadView];
    self.loadingImageV = loadView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.headerFreshView.bounds = CGRectMake(0, 0, 120, 20);
    
    self.headerFreshView.center = CGPointMake(self.mj_w*0.5, self.mj_h-20);
    
    self.label.frame = CGRectMake(30, 0, 80, 20);
    
    self.imageView.frame = CGRectMake(0, 0, 20, 20);
    
    self.loadingImageV.frame = CGRectMake(0, 0, 20, 20);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}



#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"下拉刷新";
            [self endAnimation];
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开加载更多";
            [self endAnimation];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载中...";
            [self startAnimation];
            break;
        default:
            break;
    }
}



#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    self.label.textColor = QNDAssistText153Color;
}


#pragma mark 图片旋转
- (void)startAnimation
{
    CABasicAnimation *basicAni= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAni.duration = 1;
    basicAni.repeatCount = MAXFLOAT;
    basicAni.repeatDuration = 0;
    basicAni.toValue = @(M_PI * 2);
    [self.loadingImageV.layer addAnimation:basicAni forKey:nil];
}

- (void)endAnimation
{
    [self.imageView.layer removeAllAnimations];
}



@end
