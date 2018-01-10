//
//  MineFunctionTableViewCell.m
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "MineFunctionTableViewCell.h"

@implementation MineFunctionTableViewCell


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
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = QNDFont(14.0);
    _titleLabel.textColor = black31TitleColor;
    [self.contentView addSubview:_titleLabel];
    
    _redPoint = [[UIView alloc]init];
    _redPoint.backgroundColor = QNDRGBColor(239, 99, 37);
    _redPoint.layer.cornerRadius = 3.5;
    _redPoint.clipsToBounds = YES;
    _redPoint.hidden = YES;
    [self.contentView addSubview:_redPoint];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.font = QNDFont(13.0);
    _detailLabel.textColor = QNDRGBColor(153, 153, 153);
    [self.contentView addSubview:_detailLabel];
    
    _moreview = [[UIImageView alloc]init];
    [_moreview setImage:[UIImage imageNamed:@"goin"]];
    [_moreview setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:_moreview];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.equalTo(@15);
    }];
    
    [_moreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
    
    [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_moreview.mas_left).with.offset(-7);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(7, 7));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(self);
        make.height.equalTo(@14);
    }];
}

@end
