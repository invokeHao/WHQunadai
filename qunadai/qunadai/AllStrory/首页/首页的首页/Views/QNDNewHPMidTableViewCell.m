//
//  QNDNewHPMidTableViewCell.m
//  qunadai
//
//  Created by 王浩 on 2017/12/28.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDNewHPMidTableViewCell.h"

@implementation QNDNewHPMidTableViewCell
{
    UIImageView * backImageV;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews{
    [self setupViews];
}

-(void)setupViews{
    backImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_card_bg"]];
    backImageV.contentMode = UIViewContentModeScaleAspectFit;
    backImageV.layer.cornerRadius = 5;
    backImageV.clipsToBounds = YES;
    [self.contentView addSubview:backImageV];
    
    UILabel * topLabel = [[UILabel alloc]init];
    topLabel.font = QNDFont(13.0);
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"智能撮合额度";
    topLabel.textAlignment = NSTextAlignmentCenter;
    [backImageV addSubview:topLabel];
    
    UILabel * valueLabel = [[UILabel alloc]init];
    valueLabel.font = QNDFont(55);
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.text = @"5,000";
    valueLabel.textAlignment= NSTextAlignmentCenter;
    [backImageV addSubview:valueLabel];
    
    UILabel * bottomLabel = [[UILabel alloc]init];
    bottomLabel.font = QNDFont(14.0);
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"只需填写一次信息 智能匹配多家贷款";
    [backImageV addSubview:bottomLabel];
    
    //开始布局
    [backImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-30);
    }];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@27);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@14);
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(backImageV);
        make.height.equalTo(@56);
        make.width.equalTo(@150);
    }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-30);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@15);
    }];
}

-(void)drawRect:(CGRect)rect{
    //根据需求
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* shadow2Color = ThemeColor;
    
    //// Shadow Declarations
    NSShadow* shadow2 = [[NSShadow alloc] init];
    shadow2.shadowColor = [shadow2Color colorWithAlphaComponent: CGColorGetAlpha(shadow2Color.CGColor) * 0.6];
    shadow2.shadowOffset = CGSizeMake(0, 5);
    shadow2.shadowBlurRadius = 20;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: backImageV.frame cornerRadius: 5];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2.shadowOffset, shadow2.shadowBlurRadius, [shadow2.shadowColor CGColor]);
    [color setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}


@end
