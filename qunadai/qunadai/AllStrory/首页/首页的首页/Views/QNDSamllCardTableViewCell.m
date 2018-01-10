//
//  QNDSamllCardTableViewCell.m
//  qunadai
//
//  Created by 王浩 on 2017/12/28.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDSamllCardTableViewCell.h"

#import "NSString+extention.h"

@implementation QNDSamllCardTableViewCell

{
    UIImageView * backImageV;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    backImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_small_card_bg"]];
    backImageV.contentMode = UIViewContentModeScaleAspectFit;
    backImageV.layer.cornerRadius = 5;
    backImageV.clipsToBounds = YES;
    [self.contentView addSubview:backImageV];
    
    _valueLabel = [[UILabel alloc]init];
    _valueLabel.font = QNDFont(40.0);
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.text = @"1,0000";
    _valueLabel.textAlignment= NSTextAlignmentCenter;
    [backImageV addSubview:_valueLabel];
    
    UILabel * bottomLabel = [[UILabel alloc]init];
    bottomLabel.font = QNDFont(16.0);
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"智能撮合额度";
    [backImageV addSubview:bottomLabel];
    
    //开始布局
    [backImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-20);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backImageV);
        make.top.equalTo(@27);
        make.height.equalTo(@41);
    }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-32);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@17);
    }];
}

-(void)setAmount:(NSInteger)amount{
    NSString * valueStr = [NSString getTheMutableStringWithString:FORMAT(@"%ld",amount)];
    self.valueLabel.text = valueStr;
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
