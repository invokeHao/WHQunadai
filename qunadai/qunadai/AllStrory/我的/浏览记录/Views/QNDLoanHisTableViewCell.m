//
//  QNDLoanHisTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/9/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDLoanHisTableViewCell.h"

@implementation QNDLoanHisTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = QNDFont(16.0);
    _nameLabel.textColor = black31TitleColor;
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = QNDFont(12.0);
    _timeLabel.textColor = QNDAssistText153Color;
    [self.contentView addSubview:_timeLabel];
    
    UIView * crowLine = [[UIView alloc]init];
    crowLine.backgroundColor = QNDRGBColor(242, 242, 242);
    [self.contentView addSubview:crowLine];
    
    UILabel * Label = [[UILabel alloc]init];
    Label.font = QNDFont(13.0);
    Label.textColor = QNDListDetailLabelGrayColor;
    Label.text = @"预估额度（元）";
    [self.contentView addSubview:Label];
    
    _valueLabel = [[UILabel alloc]init];
    _valueLabel.font = QNDFont(26.0);
    _valueLabel.textColor = ThemeColor;
    [self.contentView addSubview:_valueLabel];
    //分割竖线
    UIView * Hline = [[UIView alloc]init];
    Hline.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:Hline];
    
    _fastLabel = [[UILabel alloc]init];
    _fastLabel.font = QNDFont(14.0);
    _fastLabel.textColor = QNDListDetailLabelGrayColor;
    [self.contentView addSubview:_fastLabel];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.font = QNDFont(14.0);
    _dateLabel.textColor = QNDListDetailLabelGrayColor;
    [self.contentView addSubview:_dateLabel];
    
    _inspectLabel = [[UILabel alloc]init];
    _inspectLabel.font  = QNDFont(12.0);
    _inspectLabel.text = @"查看";
    _inspectLabel.textColor = [UIColor whiteColor];
    _inspectLabel.textAlignment = NSTextAlignmentCenter;
    _inspectLabel.layer.cornerRadius = 2;
    _inspectLabel.clipsToBounds = YES;
    _inspectLabel.backgroundColor = ThemeColor;
    [self.contentView addSubview:_inspectLabel];
    
    //开始布局
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@14);
        make.height.equalTo(@17);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.top.equalTo(@28);
        make.height.equalTo(@13);
    }];
    
    [crowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.top.mas_equalTo(_timeLabel.mas_bottom).with.offset(5);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.bottom.equalTo(@-20);
        make.height.equalTo(@14);
    }];
    

    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.bottom.mas_equalTo(Label.mas_top).with.offset(-15);
        make.height.equalTo(@27);
    }];
    
    CGFloat lineX = [self numberWithFloat:14];
    [Hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Label.mas_right).with.offset(lineX);
        make.top.mas_equalTo(crowLine.mas_bottom).with.offset(8);
        make.bottom.equalTo(@-8);
        make.width.equalTo(@0.5);
    }];

    CGFloat fastX = [self numberWithFloat:35];
    [_fastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Hline.mas_right).with.offset(fastX);
        make.top.mas_equalTo(crowLine.mas_bottom).with.offset(20);
        make.height.equalTo(@16);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_fastLabel);
        make.bottom.equalTo(@-20);
        make.height.equalTo(@14);
    }];

    [_inspectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.bottom.equalTo(@-33);
        make.size.mas_equalTo(CGSizeMake(67, 24));
    }];
}

-(void)setModel:(productLoanModel *)model{
    _model = model;
    if (model) {
        _timeLabel.text = _model.browsingTime;
        _nameLabel.text = model.productName;
        _valueLabel.text = FORMAT(@"%ld",model.amtMax);
        _fastLabel.text = [model getTheLoanTimeStr];
        _dateLabel.text = [NSString stringWithFormat:@"贷款期限%ld%@",model.termMax,model.termUnit];
    }
}


-(void)setFrame:(CGRect)frame{
    frame.size.height -= 10;
    [super setFrame:frame];
}

-(CGFloat)numberWithFloat:(CGFloat)value{
    //适配屏幕宽度需要按比例算
    CGFloat realValue = value * ViewWidth / 375;
    return realValue;
}


-(void)drawRect:(CGRect)rect{
    //根据需求
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* shadow2Color = ThemeColor;
    
    //// Shadow Declarations
    NSShadow* shadow2 = [[NSShadow alloc] init];
    shadow2.shadowColor = [shadow2Color colorWithAlphaComponent: CGColorGetAlpha(shadow2Color.CGColor) * 0.7];
    shadow2.shadowOffset = CGSizeMake(0, 2);
    shadow2.shadowBlurRadius = 6;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: _inspectLabel.frame cornerRadius: 2];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2.shadowOffset, shadow2.shadowBlurRadius, [shadow2.shadowColor CGColor]);
    [color setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}


@end
