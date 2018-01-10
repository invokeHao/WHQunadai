//
//  QNDDetialTopView.m
//  qunadai
//
//  Created by wang on 2017/9/25.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDDetialTopView.h"

@implementation QNDDetialTopView
{
    NSString * _valueStr;
    UIView * _backView;
}
-(instancetype)initWithValueStr:(NSString *)valueStr{
    self = [super init];
    if (self) {
        _valueStr = valueStr;
    }
    return self;
}

-(void)layoutSubviews{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(12, 10, ViewWidth-24, 253)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 2;
    _backView.clipsToBounds = YES;
    [self addSubview:_backView];
    
    //中间的圆
    UIImageView * circleView = [[UIImageView alloc]init];
    [circleView setImage:[UIImage imageNamed:@"circle_bg"]];
    [_backView addSubview:circleView];
    
    _valueLabel = [[UILabel alloc]init];
    _valueLabel.font = QNDFont(42.0);
    _valueLabel.textColor = ThemeColor;
    _valueLabel.text = _valueStr;
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    [circleView addSubview:_valueLabel];
    
    UILabel * descLabel = [[UILabel alloc]init];
    descLabel.font = QNDFont(14.0);
    descLabel.textColor = QNDRGBColor(185, 185, 185);
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = @"可借款额度";
    [circleView addSubview:descLabel];
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backView);
        make.top.equalTo(@25);
        make.size.mas_equalTo(CGSizeMake(156, 156));
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@46);
        make.centerX.mas_equalTo(circleView);
        make.height.equalTo(@43);
    }];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_valueLabel.mas_bottom).with.offset(15);
        make.centerX.mas_equalTo(circleView);
        make.height.equalTo(@15);
    }];
    //下面的两个label
    UILabel * rateLabel = [[UILabel alloc]init];
    rateLabel.font = QNDFont(18.0);
    rateLabel.textColor = ThemeColor;
    rateLabel.text = @"借款利率0.78%";
    [_backView addSubview:rateLabel];
    
    _payMonthLabel = [[UILabel alloc]init];
    _payMonthLabel.font = QNDFont(18.0);
    _payMonthLabel.textColor = ThemeColor;
    _payMonthLabel.text = @"每月还款366.67";
    _payMonthLabel.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_payMonthLabel];
    
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.bottom.equalTo(@-22);
        make.height.equalTo(@19);
    }];
    
    [_payMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-16);
        make.bottom.mas_equalTo(rateLabel);
        make.height.mas_equalTo(rateLabel);
    }];
}

-(void)drawRect:(CGRect)rect{
    //根据需求
    CGContextRef context = UIGraphicsGetCurrentContext();
    //// Color Declarations
    UIColor* color = [UIColor whiteColor];
    UIColor* shadow1Color = QNDRGBColor(154, 154, 154);
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [shadow1Color colorWithAlphaComponent: CGColorGetAlpha(shadow1Color.CGColor) * 0.5];
    shadow.shadowOffset = CGSizeMake(0, 2);
    shadow.shadowBlurRadius = 4;
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:_backView.frame  cornerRadius: 2];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
    rectanglePath.lineWidth = 0.1;
    [color setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}

@end
