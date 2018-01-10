//
//  QNDLoanCircleView.m
//  qunadai
//
//  Created by wang on 2017/9/25.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDMidCircleView.h"

@interface QNDMidCircleView()
/**
 *  屏帧定时器
 */
@property (nonatomic,strong)CADisplayLink *link;

@end

@implementation QNDMidCircleView
{
    UIView * _backView;
    int value;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, ViewWidth-24, 296)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 2;
    _backView.clipsToBounds = YES;
    [self addSubview:_backView];
    
    UIImageView * recommandView = [[UIImageView alloc]init];
    [recommandView setImage:[UIImage imageNamed:@"red_bg"]];
    [_backView addSubview:recommandView];
    
    UILabel * recommandLabel = [[UILabel alloc]init];
    recommandLabel.text = @"为您推荐";
    [recommandLabel setFont:QNDFont(14.0)];
    [recommandLabel setTextColor:[UIColor whiteColor]];
    [recommandView addSubview:recommandLabel];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = lightGrayBackColor;
    [_backView addSubview:line];
    
    [recommandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(70, 22));
    }];
    [recommandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(recommandView);
        make.height.equalTo(@15);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.mas_equalTo(recommandView.mas_bottom).with.offset(10);
        make.height.equalTo(@1);
    }];
    //中间的圆
    UIImageView * circleView = [[UIImageView alloc]init];
    [circleView setImage:[UIImage imageNamed:@"circle_bg"]];
    [_backView addSubview:circleView];
    
    _valueLabel = [[UILabel alloc]init];
    _valueLabel.font = QNDFont(42.0);
    _valueLabel.textColor = QNDRGBColor(215, 29, 29);
    _valueLabel.text = @"500";
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
        make.top.mas_equalTo(line.mas_bottom).with.offset(25);
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
    
    _totalValueLabel = [[UILabel alloc]init];
    _totalValueLabel.font = QNDFont(18.0);
    _totalValueLabel.textColor = ThemeColor;
    _totalValueLabel.text = @"总额度1000";
    [_backView addSubview:_totalValueLabel];
    
    [_totalValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backView);
        make.bottom.equalTo(@-25);
        make.height.equalTo(@19);
    }];
}

- (void)drawRect:(CGRect)rect {
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

#pragma makr - 懒加载定时器
-(CADisplayLink *)link{
    if (_link == nil ) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateValue)];
        _link.frameInterval = 1;
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

-(void)setTotalValue:(int)totalValue{
    value = 0;
    _totalValue = totalValue;
    [self.link setPaused:NO];
}

-(void)animateValue{
    if (value < self.totalValue) {
        value += self.totalValue/120;
        self.valueLabel.text = FORMAT(@"%d",value);
    }
    else{
        [self.link setPaused:YES];
        value = 0;
        self.valueLabel.text = FORMAT(@"%d",self.totalValue);
    }
}


@end
