//
//  rankView.h
//  Yizhenapp
//
//  Created by augbase on 16/5/6.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rankView : UIView
/**
 *  构造方法
 *
 *  @param lineColor 线的颜色
 *  @param loopColor 圆环颜色
 */
-(instancetype)initWithLineColor:(UIColor*)lineColor
                       loopColor:(UIColor*)loopColor andNum:(int)num;
/**
 *  进度
 */
@property (nonatomic,assign)CGFloat percent;
/**
 *  进度字体颜色
 */
@property (nonatomic,strong)UIColor* percentColor;
/**
 *  进度的单位，例如 % 、分 、‰ 默认为空
 */
@property (nonatomic,copy)NSString* percentUnit;

@property (nonatomic,copy)NSString* lessPoint;

/**
 *  线颜色，默认橘色
 */
@property (nonatomic,strong)UIColor* lineColor;
/**
 *  圆环颜色，默认绿色
 */
@property (nonatomic,strong)UIColor *loopColor;

/**
 *  是否执行动画
 */
@property (nonatomic,assign,getter=isAnimatable)BOOL animatable;
/**
 *  标题
 */
@property (nonatomic,copy)NSString* title;
/**
 *  标题颜色
 */
@property (nonatomic,strong)UIColor *titleColor;


@property (nonatomic,strong)UILabel * valueLabel;

@property (nonatomic,assign)int ValueNum;//额度数


@end
