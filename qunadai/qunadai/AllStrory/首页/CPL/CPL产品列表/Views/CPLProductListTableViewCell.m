//
//  CPLProductListTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLProductListTableViewCell.h"

@interface CPLProductListTableViewCell()



@property (strong,nonatomic) UILabel * nameLabel;

@property (strong,nonatomic) UILabel * statusLabel;

@property (strong,nonatomic) UILabel * valueLabel;

@property (strong,nonatomic) UILabel * descLabel;

@end

@implementation CPLProductListTableViewCell
{
    UILabel * _applyLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _nameLabel = [[UILabel alloc]init];
    [_nameLabel setFont:QNDFont(16.0)];
    [_nameLabel setTextColor:blackTitleColor];
    [self.contentView addSubview:_nameLabel];
    
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
    Vlabel.textColor = QNDRGBColor(195, 195, 195);
    Vlabel.text = @"额度范围（元）";
    [self.contentView addSubview:Vlabel];
    //分割竖线
    UIView * Hline = [[UIView alloc]init];
    Hline.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:Hline];
    
    _descLabel = [[UILabel alloc]init];
    _descLabel.font = QNDFont(14.0);
    _descLabel.textColor = QNDRGBColor(181, 188, 204);
    _descLabel.numberOfLines = 2;
    [self.contentView addSubview:_descLabel];
    
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.font = QNDFont(13.0);
    _statusLabel.textColor = ThemeColor;
    _statusLabel.hidden = YES;
    [self.contentView addSubview:_statusLabel];

    _applyLabel = [[UILabel alloc]init];
    _applyLabel.text = @"立即申请";
    _applyLabel.textColor = [UIColor whiteColor];
    _applyLabel.backgroundColor = ThemeColor;
    _applyLabel.textAlignment = NSTextAlignmentCenter;
    _applyLabel.font = QNDFont(13.0);
    _applyLabel.layer.cornerRadius = 15;
    _applyLabel.clipsToBounds = YES;
    [self.contentView addSubview:_applyLabel];
    
    //开始布局
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@14);
        make.height.equalTo(@17);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(_nameLabel);
        make.height.equalTo(@14);
    }];
    
    [crowsLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.right.equalTo(@0);
        make.top.equalTo(@50);
        make.height.equalTo(@0.5);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(crowsLine.mas_bottom).with.offset(13);
        make.height.equalTo(@27);
    }];
    
    [Vlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_valueLabel);
        make.bottom.equalTo(@-12);
        make.height.equalTo(@14);
    }];
    
    CGFloat lineX = [self numberWithFloat:14];
    [Hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Vlabel.mas_right).with.offset(lineX);
        make.top.mas_equalTo(crowsLine.mas_bottom).with.offset(8);
        make.bottom.equalTo(@-8);
        make.width.equalTo(@0.5);
    }];
    
    [_applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.bottom.equalTo(@-27);
        make.size.mas_equalTo(CGSizeMake(68, 30));
    }];

    CGFloat fastX = [self numberWithFloat:25];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Hline.mas_right).with.offset(fastX);
        make.centerY.mas_equalTo(_applyLabel);
        make.right.mas_equalTo(_applyLabel.mas_left).with.offset(-17);
    }];
}

-(void)setModel:(CPLProductModel *)model{
    _model = model;
    _nameLabel.text = _model.name;
    _valueLabel.text = [NSString stringWithFormat:@"%ld",model.max_amount];
    _descLabel.text = _model.desc;
    switch (_model.applicationType) {
        case 0:{
            _statusLabel.text = @"未完成";
            _statusLabel.textColor = QNDRGBColor(59, 109, 226);
        break;}
        case 1:{
            _statusLabel.text = @"审核中";
            _statusLabel.textColor = ThemeColor;
            break;}
        case 2:{
            _statusLabel.text = @"审核未通过";
            _statusLabel.textColor = QNDRGBColor(59, 109, 226);
            break;}
        case 3:{
            _statusLabel.text = @"审核通过，等待联系";
            _statusLabel.textColor = ThemeColor;
            break;}
        default:
            break;
    }
}

-(void)ShowTheApplicationStatus:(BOOL)status{
    _applyLabel.text = status ? @"申请状态" : @"立即申请";
    _statusLabel.hidden = status ? NO : YES;
}

-(CGFloat)numberWithFloat:(CGFloat)value{
    //适配屏幕宽度需要按比例算
    CGFloat realValue = value;
    if (ViewWidth<321) {
        realValue = 10;
    }
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
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: _applyLabel.frame cornerRadius: 15];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2.shadowOffset, shadow2.shadowBlurRadius, [shadow2.shadowColor CGColor]);
    [color setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}


@end
