//
//  YellowAlertTableViewCell.m
//  qunadai
//
//  Created by wang on 17/3/31.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "YellowAlertTableViewCell.h"

@implementation YellowAlertTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    self.backgroundColor = [UIColor colorWithRed:251.0/255.0f green:236.0/255.0f blue:213.0/255.0f alpha:1.0];
    UIImageView * iconView = [[UIImageView alloc]init];
    [iconView setImage:[UIImage imageNamed:@"content_icon_remind"]];
    [iconView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:iconView];
    
    _alertLabel = [[UILabel alloc]init];
    _alertLabel.font = QNDFont(13.0);
    _alertLabel.textColor = [UIColor colorWithRed:243.0/255.0f green:146.0/255.0f blue:30.0/255.0f alpha:1.0];
    _alertLabel.text = @"必须确保是本人的银行卡帐号";
    [self.contentView addSubview:_alertLabel];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"xiaochahao"] forState:UIControlStateNormal];
    [closeBtn setContentMode:UIViewContentModeCenter];
    [closeBtn addTarget:self action:@selector(cleanTheYellowAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.height.equalTo(@14);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}

-(void)cleanTheYellowAlertView:(UIButton*)button{
    _yellowBlock();
}


@end
