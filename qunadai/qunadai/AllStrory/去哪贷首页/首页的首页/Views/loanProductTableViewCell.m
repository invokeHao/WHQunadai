//
//  loanProductTableViewCell.m
//  qunadai
//
//  Created by wang on 17/4/1.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#define SuiJiShu (arc4random()%10000)

#import "loanProductTableViewCell.h"

#import "NSString+extention.h"

@interface loanProductTableViewCell()
{
    UIButton * _applyProBtn;
}

@property (strong,nonatomic) UIButton * applicationBtn;

@property (strong,nonatomic) UILabel * hadApplyLabel;

@property (strong,nonatomic) UILabel * valueLabel;

@property (strong,nonatomic) UILabel * fastLabel;

@property (strong,nonatomic) UILabel * dateLabel;

@end

@implementation loanProductTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    
    _nameLabel = [[UILabel alloc]init];
    [_nameLabel setFont:QNDFont(16.0)];
    [_nameLabel setTextColor:blackTitleColor];
    [self.contentView addSubview:_nameLabel];
    
    _applicationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_applicationBtn setTitle:@" 申请过了？" forState:UIControlStateNormal];
    [_applicationBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [_applicationBtn.titleLabel setFont:QNDFont(13.0)];
    [_applicationBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    _applicationBtn.layer.cornerRadius = 15;
    _applicationBtn.layer.borderColor = ThemeColor.CGColor;
    _applicationBtn.layer.borderWidth = 1;
    [_applicationBtn addTarget:self action:@selector(pressToEnsureThepro:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview: _applicationBtn];
    
    _hadApplyLabel = [[UILabel alloc]init];
    _hadApplyLabel.font = QNDFont(13.0);
    _hadApplyLabel.text = @"已申请";
    _hadApplyLabel.textColor = ThemeColor;
    [self.contentView addSubview:_hadApplyLabel];
    
    //横线
    UIView * crowsLine = [[UIView alloc]init];
    crowsLine.backgroundColor = lightGrayBackColor;
    [self.contentView addSubview:crowsLine];
    //金额
    _valueLabel = [[UILabel alloc]init];
    _valueLabel.font = QNDFont(26.0);
    _valueLabel.textColor = ThemeColor;
    [self.contentView addSubview:_valueLabel];
    
    //金额下面的显示label
    UILabel * Vlabel = [[UILabel alloc]init];
    Vlabel.font = QNDFont(13.0);
    Vlabel.textColor = QNDListDetailLabelGrayColor;
    Vlabel.text = @"最大额度（元）";
    [self.contentView addSubview:Vlabel];
    //分割竖线
    UIView * Hline = [[UIView alloc]init];
    Hline.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:Hline];
    
    //中间的三条描述
    _fastLabel = [[UILabel alloc]init];
    _fastLabel.font = QNDFont(14.0);
    _fastLabel.textColor = QNDListDetailLabelGrayColor;
    [self.contentView addSubview:_fastLabel];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.font = QNDFont(14.0);
    _dateLabel.textColor = QNDListDetailLabelGrayColor;
    [self.contentView addSubview:_dateLabel];
    
    _applyProBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_applyProBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    [_applyProBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _applyProBtn.backgroundColor = ThemeColor;
    _applyProBtn.titleLabel.font = QNDFont(13.0);
    _applyProBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _applyProBtn.layer.cornerRadius = 15;
    _applyProBtn.clipsToBounds = YES;
    [_applyProBtn addTarget:self action:@selector(pressToDirectApply:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_applyProBtn];
    
  //开始布局
    [crowsLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@-96);
        make.height.equalTo(@0.5);
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.bottom.mas_equalTo(crowsLine.mas_top).with.offset(-15);
        make.height.equalTo(@17);
    }];
    
    [_applicationBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.bottom.mas_equalTo(crowsLine.mas_top).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(82, 30));
    }];
    
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(crowsLine.mas_bottom).with.offset(13);
        make.height.equalTo(@27);
    }];
    
    [Vlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_valueLabel);
        make.bottom.equalTo(@-20);
        make.height.equalTo(@14);
    }];
    
    CGFloat lineX = [self numberWithFloat:14];
    [Hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Vlabel.mas_right).with.offset(lineX);
        make.top.mas_equalTo(crowsLine.mas_bottom).with.offset(8);
        make.bottom.equalTo(@-8);
        make.width.equalTo(@0.5);
    }];
    CGFloat fastX = [self numberWithFloat:35];
    [_fastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Hline.mas_right).with.offset(fastX);
        make.top.mas_equalTo(crowsLine.mas_bottom).with.offset(20);
        make.height.equalTo(@16);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_fastLabel);
        make.bottom.equalTo(@-20);
        make.height.equalTo(@14);
    }];
    [_applyProBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.bottom.equalTo(@-33);
        make.size.mas_equalTo(CGSizeMake(82, 30));
    }];
    
    [_hadApplyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.centerY.mas_equalTo(_nameLabel);
        make.height.equalTo(@14);
    }];
}

-(void)setModel:(productLoanModel *)model{
    _model = model;
    if (model) {
        _hadApplyLabel.hidden = !_model.applied;
        _nameLabel.text = _model.productName;
        _applicationBtn.hidden = _model.applied;
        _valueLabel.text = [NSString stringWithFormat:@"%ld",model.amtMax];
        _fastLabel.text = [_model getTheLoanTimeStr];
        _dateLabel.text = [NSString stringWithFormat:@"贷款期限%ld%@",model.termMax,model.termUnit];
    }
}

-(void)pressToEnsureThepro:(UIButton*)button{
    @WHWeakObj(self);
    [TalkingData trackEvent:@"申请过了按钮" label:@"申请过了按钮"];
    Weakself.orderB(_model.productCode,_model.productName);
}

-(void)pressToDirectApply:(UIButton*)button{
    [TalkingData trackEvent:@"首页申请按钮" label:@"首页申请按钮"];
    _applyB(_model.productName,_model.productUrl,_model.productCode);
}

-(CGFloat)numberWithFloat:(CGFloat)value{
    //适配屏幕宽度需要按比例算
    CGFloat realValue = value * ViewWidth / 375;
    return realValue;
}

-(void)setFrame:(CGRect)frame{
    if (frame.size.height>130) {
        frame.size.height -=10;
    }
    [super setFrame:frame];
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
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: _applyProBtn.frame cornerRadius: 15];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2.shadowOffset, shadow2.shadowBlurRadius, [shadow2.shadowColor CGColor]);
    [color setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}


@end
