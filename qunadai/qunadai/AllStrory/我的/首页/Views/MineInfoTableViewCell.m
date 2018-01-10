//
//  MineInfoTableViewCell.m
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "MineInfoTableViewCell.h"
#import "WHVerify.h"
#import "NSString+extention.h"

@implementation MineInfoTableViewCell
{
    UIButton * _valueBtn;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_avatarBtn setContentMode:UIViewContentModeScaleAspectFit];
    _avatarBtn.layer.cornerRadius =25;
    _avatarBtn.clipsToBounds = YES;
    [_avatarBtn setImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
    [_avatarBtn addTarget:self action:@selector(pressToSeeUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_avatarBtn];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = QNDFont(14.0);
    _nameLabel.textColor = black74TitleColor;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    _valueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_valueBtn setTitle:@"运营商认证 口子随便撸" forState:UIControlStateNormal];
    [_valueBtn setBackgroundColor:ThemeColor];
    [_valueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_valueBtn.titleLabel setFont:QNDFont(13)];
    _valueBtn.layer.cornerRadius = 15;
    _valueBtn.clipsToBounds = YES;
    [_valueBtn addTarget:self action:@selector(pressToGetTheLoanValue:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_valueBtn];
    
    [_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatarBtn.mas_bottom).with.offset(7);
        make.centerX.mas_equalTo(self);
        make.height.equalTo(@15);
    }];
    
    [_valueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
}

-(void)setModel:(AccountModel *)model{
    _model = model;
    [_avatarBtn sd_setImageWithURL:[NSURL URLWithString:_model.headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_boy"]];
    [_nameLabel setText:model.username];
    //获取到字宽
    CGFloat width = [model.mobileAuth sizeWithFont:QNDFont(13.0) maxSize:CGSizeMake(MAXFLOAT, 14)].width+15;
    [_valueBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(width, 30));
    }];
    [_valueBtn setTitle:model.mobileAuth forState:UIControlStateNormal];
    
    if (_model.username.length<1||[WHVerify checkTelNumber:_model.username]) {
        NSString*bStr = [self.model.mobile substringWithRange:NSMakeRange(3,4)];
        NSString * phone = [self.model.mobile stringByReplacingOccurrencesOfString:bStr withString:@"****"];
        _nameLabel.text = phone;
    }
}

-(void)pressToSeeUserInfo:(UIButton*)button{
    _userB();
}

-(void)pressToGetTheLoanValue:(UIButton*)button{
    _valueB();
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
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: _valueBtn.frame cornerRadius: 15];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2.shadowOffset, shadow2.shadowBlurRadius, [shadow2.shadowColor CGColor]);
    [color setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}

@end
