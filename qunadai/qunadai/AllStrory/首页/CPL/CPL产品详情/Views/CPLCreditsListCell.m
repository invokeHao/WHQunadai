//
//  CPLCreditsListCell.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLCreditsListCell.h"

@interface CPLCreditsListCell ()

@property (strong,nonatomic)UIImageView * iconView;

@property (strong,nonatomic)UILabel * nameLabel;

@property (strong,nonatomic)UILabel * verifyLabel;//认证状态label

@end

@implementation CPLCreditsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = QNDFont(14.0);
    _nameLabel.textColor = black74TitleColor;
    [self.contentView addSubview:_nameLabel];
    
    _verifyLabel = [[UILabel alloc]init];
    _verifyLabel.font = QNDFont(12.0);
    _verifyLabel.textColor = [UIColor whiteColor];
    _verifyLabel.backgroundColor = QNDRGBColor(256, 184, 64);
    _verifyLabel.layer.cornerRadius = 13.5;
    _verifyLabel.text = @"已认证";
    _verifyLabel.textAlignment = NSTextAlignmentCenter;
    _verifyLabel.clipsToBounds = YES;
    [self.contentView addSubview:_verifyLabel];
    
    UIImageView * moreView = [[UIImageView alloc]init];
    [moreView setImage:[UIImage imageNamed:@"icon_next_page"]];
    [self.contentView addSubview:moreView];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = QNDRGBColor(242, 242, 242);
    [self.contentView addSubview:lineView];
    
    //开始布局
//    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(@12);
//        make.size.mas_equalTo(CGSizeMake(22, 22));
//    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.equalTo(@12);
        make.height.equalTo(@15);
    }];
    
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 19));
    }];
    
    [_verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(moreView.mas_left).with.offset(-4);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(56, 27));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@44);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
}

-(void)setModel:(CPLCreditListModel *)model{
    _model = model;
    //基本信息认证
    if ([_model.credit_code isEqualToString:@"basic"]) {
        [_iconView setImage:[UIImage imageNamed:@"content_icon_real"]];
    }else if ([_model.credit_code isEqualToString:@"mobile"]){
        //手机认证
        [_iconView setImage:[UIImage imageNamed:@"cpl_icon_phone"]];
    }else if ([_model.credit_code isEqualToString:@"zhimafen"]){
        //芝麻认证
        [_iconView setImage:[UIImage imageNamed:@"content_icon_sesame"]];
    }
    _nameLabel.text = _model.credit_name;
    if (_model.credit_status == 2) {
        _verifyLabel.backgroundColor = ThemeColor;
        _verifyLabel.text = @"已认证";
    }else{
        _verifyLabel.backgroundColor = QNDRGBColor(195, 195, 195);
        _verifyLabel.text = @"未认证";
    }
}


@end
