//
//  CPLApplicationProCell.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLApplicationProCell.h"

@interface CPLApplicationProCell ()

@property (strong,nonatomic) UILabel * nameLabel;

@property (strong,nonatomic)UILabel * timeLabel;//申请时间

@property (strong,nonatomic)UILabel * valueLabel;//申请额度

@property (strong,nonatomic)UILabel * durationLabel;//申请期限

@end

@implementation CPLApplicationProCell
{
    UILabel * phoneLabel;
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
    _nameLabel = [[UILabel alloc]init];
    [_nameLabel setFont:QNDFont(16.0)];
    [_nameLabel setTextColor:blackTitleColor];
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc]init];
    [_timeLabel setFont:QNDFont(14.0)];
    [_timeLabel setTextColor:QNDRGBColor(181, 188, 204)];
    [self.contentView addSubview:_timeLabel];
    
    UILabel * agentLabel = [[UILabel alloc]init];
    agentLabel.text = @"信贷经理电话";
    agentLabel.textColor = QNDRGBColor(181, 188, 204);
    agentLabel.font = QNDFont(14.0);
    [self.contentView addSubview:agentLabel];
    
    phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"请等待信贷经理联系";
    phoneLabel.font = QNDFont(14.0);
    phoneLabel.textColor = QNDRGBColor(181, 188, 204);
    [self.contentView addSubview:phoneLabel];
    
    UIView * crowLine = [[UIView alloc]init];
    crowLine.backgroundColor = QNDRGBColor(242, 242, 242);
    [self.contentView addSubview:crowLine];
    
    _valueLabel = [self setupMainLabel];
    
    UILabel * valueUnitLabel = [self setupUnitLabelWithTitle:@"申请额度(元)"];
    
    _durationLabel = [self setupMainLabel];
    
    UILabel * durationUnitLabel = [self setupUnitLabelWithTitle:@"期限"];
    
    UILabel * ratelabel = [self setupMainLabel];
    ratelabel.text = @"待定";
    
    UILabel * rateUnitLabel = [self setupUnitLabelWithTitle:@"日费率"];
    //开始布局
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@14);
        make.height.equalTo(@17);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameLabel);
        make.right.equalTo(@-12);
        make.height.equalTo(@15);
    }];
    
    [agentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(15);
        make.height.equalTo(@15);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(agentLabel);
        make.height.equalTo(@15);
    }];
    
    [crowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.right.equalTo(@0);
        make.top.mas_equalTo(agentLabel.mas_bottom).with.offset(10);
        make.height.equalTo(@1);
    }];
    //三个布局
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.mas_equalTo(crowLine.mas_bottom).with.offset(15);
        make.height.equalTo(@27);
    }];
    [valueUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_valueLabel);
        make.bottom.equalTo(@-12);
        make.height.equalTo(@14);
    }];
    
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_valueLabel);
        make.height.equalTo(_valueLabel);
    }];
    
    [durationUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_durationLabel);
        make.bottom.mas_equalTo(valueUnitLabel);
        make.height.mas_equalTo(valueUnitLabel);
    }];
    
    [ratelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.top.mas_equalTo(_valueLabel);
        make.height.mas_equalTo(_valueLabel);
    }];
    
    [rateUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ratelabel);
        make.bottom.mas_equalTo(valueUnitLabel);
        make.height.mas_equalTo(valueUnitLabel);
    }];
}


-(void)setModel:(CPLApplicationDetailModel *)model{
    _model = model;
    if (model) {
        _nameLabel.text = _model.name;
        _valueLabel.text = FORMAT(@"%ld",_model.request_amount);
        _durationLabel.text = FORMAT(@"%ld%@",_model.duration_number,[_model create_durationType]);
        _timeLabel.text = _model.application_time;
        if (_model.contact_number) {
            phoneLabel.text = _model.contact_number;
        }
    }
}


-(UILabel*)setupUnitLabelWithTitle:(NSString*)title{
    UILabel * label = [[UILabel alloc]init];
    label.font = QNDFont(13.0);
    label.textColor = QNDRGBColor(207, 212, 220);
    label.text = title;
    [self.contentView addSubview:label];
    return label;
}

-(UILabel *)setupMainLabel{
    UILabel * label = [[UILabel alloc]init];
    label.font = QNDFont(26.0);
    label.textColor = ThemeColor;
    [self.contentView addSubview:label];
    return label;
}

-(void)setFrame:(CGRect)frame{
    if (frame.size.height>150) {
        frame.size.height -=10;
    }
    [super setFrame:frame];
}

@end
