//
//  verifyTableViewCell.m
//  qunadai
//
//  Created by wang on 17/3/30.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "verifyTableViewCell.h"

@implementation verifyTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _iconView = [[UIImageView alloc]init];
    [_iconView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:_iconView];
    
    _titlelabel = [[UILabel alloc]init];
    [_titlelabel setFont:QNDFont(14.0)];
    [_titlelabel setTextColor:black74TitleColor];
    [self.contentView addSubview:_titlelabel];
    
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyBtn.titleLabel setFont:QNDFont(12.0)];
    _verifyBtn.layer.cornerRadius = 2;
    _verifyBtn.backgroundColor = [UIColor whiteColor];
    [_verifyBtn setTitleColor:QNDRGBColor(153, 153, 153) forState:UIControlStateNormal];
    _verifyBtn.layer.borderColor = QNDRGBColor(195, 195, 195).CGColor;
    _verifyBtn.layer.borderWidth= 0.5;
    _verifyBtn.clipsToBounds= YES;
    _verifyBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_verifyBtn];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@12);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.height.equalTo(@15);
    }];
    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(56, 27));
    }];
}

-(void)setModel:(VerifyFunctionModel *)model{
    _model = model;
    
    [_iconView setImage:[UIImage imageNamed:_model.iconStr]];
    [_titlelabel setText:_model.name];
    
    if (_model.type==verifySuccessType) {
        [_verifyBtn setBackgroundColor:ThemeColor];
        [_verifyBtn setTitle:@"已认证" forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _verifyBtn.layer.borderColor = [UIColor clearColor].CGColor;
    }else if (_model.type == verifingType){
//        [_verifyBtn setTitle:@"认证中" forState:UIControlStateNormal];
//        [_verifyBtn setBackgroundColor:[UIColor colorWithRed:119/255.0 green:165/255.0 blue:248/255.0 alpha:0.5]];
//        [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _verifyBtn.layer.borderColor = QNDRGBColor(119, 165, 248).CGColor;
        [_verifyBtn setImage:[UIImage imageNamed:@"message_button"] forState:UIControlStateNormal];
    }
    else if(_model.type == verifyUndoType){
        [_verifyBtn setTitle:@"未认证" forState:UIControlStateNormal];
        _verifyBtn.backgroundColor = [UIColor whiteColor];
        [_verifyBtn setTitleColor:QNDRGBColor(153, 153, 153) forState:UIControlStateNormal];
        _verifyBtn.layer.borderColor = QNDRGBColor(195, 195, 195).CGColor;
    }else if(_model.type == verifyFailedType){
        [_verifyBtn setTitle:@"信息错误" forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:93.0/255.0 blue:76.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        _verifyBtn.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:93.0/255.0 blue:76.0/255.0 alpha:1.0].CGColor;
    }
}


@end
