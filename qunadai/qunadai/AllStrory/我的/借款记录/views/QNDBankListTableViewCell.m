//
//  QNDBankListTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/9/26.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDBankListTableViewCell.h"

@implementation QNDBankListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    UIImageView * backView = [[UIImageView alloc]init];
    [backView setImage:[UIImage imageNamed:@"bank_bg"]];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.height.equalTo(@110);
    }];
    
    UIImageView * iconView = [[UIImageView alloc]init];
    [iconView setImage:[UIImage imageNamed:@"banklist_icon_bank"]];
    [backView addSubview:iconView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = QNDFont(18);
    _nameLabel.textColor = [UIColor whiteColor];
    [backView addSubview:_nameLabel];
    
    UILabel * cardLabel = [[UILabel alloc]init];
    cardLabel.font =QNDFont(12.0);
    cardLabel.textColor = [UIColor whiteColor];
    cardLabel.text = @"储蓄卡";
    [backView addSubview:cardLabel];
    
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.font = QNDFont(20);
    _numberLabel.textColor = [UIColor whiteColor];
    [backView addSubview:_numberLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@32);
        make.top.equalTo(@18);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.left.mas_equalTo(iconView.mas_right).with.offset(10);
        make.height.equalTo(@19);
    }];
    
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(5);
        make.height.equalTo(@13);
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView);
        make.bottom.equalTo(@-16);
        make.height.equalTo(@21);
    }];
}

-(void)setNumberLabelWithBankNum:(NSString *)bankNum{
    NSInteger a = bankNum.length/4;//共有几段
    NSInteger b = bankNum.length%4;//最后一段有几位
    NSString * endStr = [bankNum substringFromIndex:bankNum.length-b];
    NSString * resultStr = @"";
    for (int i =1; i<a+1; i++) {
        resultStr = [resultStr stringByAppendingString:@"****  "];
    }
    resultStr = [resultStr stringByAppendingString:endStr];
    
    _numberLabel.text = resultStr;
}
@end

