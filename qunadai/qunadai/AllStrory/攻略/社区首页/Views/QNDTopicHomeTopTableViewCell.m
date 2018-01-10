//
//  QNDTopicHomeTopTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/11/14.
//  Copyright © 2017年 Hebei Yulan Investment Management Co.,Ltd. All rights reserved.
//

#import "QNDTopicHomeTopTableViewCell.h"

@implementation QNDTopicHomeTopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    UIView * leftView = [self createViewWithIcon:@"find_icon_credit" andFrame:CGRectMake(0, 0, ViewWidth/2, 72) andTitleLabel:@"办信用卡" andTipsLabel:@"更多银行选择"];
    [self.contentView addSubview:leftView];
    
    UITapGestureRecognizer * leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(creditTap:)];
    [leftView addGestureRecognizer:leftTap];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(ViewWidth/2-1, 20, 1, 32)];
    lineView.backgroundColor = QNDRGBColor(242, 242, 242);
    [self.contentView addSubview:lineView];
    
    UIView * rightView = [self createViewWithIcon:@"find_icon_help" andFrame:CGRectMake(ViewWidth/2, 0, ViewWidth/2, 72) andTitleLabel:@"帮助中心" andTipsLabel:@"贷款需求解答"];
    [self.contentView addSubview:rightView];
    UITapGestureRecognizer * rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpTap:)];
    [rightView addGestureRecognizer:rightTap];
    
}

-(UIView*)createViewWithIcon:(NSString*)imageStr andFrame:(CGRect)frame andTitleLabel:(NSString*)title andTipsLabel:(NSString*)tips {
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor clearColor];
    backView.userInteractionEnabled = YES;
    [backView setFrame:frame];
    [self.contentView addSubview:backView];
    
    UIImageView * iconView = [[UIImageView alloc]init];
    [iconView setImage:[UIImage imageNamed:imageStr]];
    iconView.layer.cornerRadius = 18;
    iconView.clipsToBounds = YES;
    [backView addSubview:iconView];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = QNDFont(16.0);
    titleLabel.textColor = black31TitleColor;
    titleLabel.text = title;
    [backView addSubview:titleLabel];
    
    UILabel * tipsLabel = [[UILabel alloc]init];
    tipsLabel.font = QNDFont(11.0);
    tipsLabel.textColor = QNDRGBColor(176, 176, 176);
    tipsLabel.text = tips;
    [backView addSubview:tipsLabel];
    //开始布局
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([self numberWithTheFloatMargin:24.0]);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView.mas_right).with.offset(15*375/ViewWidth);
        make.top.equalTo(@16);
        make.height.equalTo(@17);
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.bottom.equalTo(@-15);
        make.height.equalTo(@12);
    }];
    
    return backView;
}

-(void)creditTap:(UITapGestureRecognizer*)tap{
    _cBlock();
}

-(void)helpTap:(UITapGestureRecognizer*)tap{
    _hBlock();
}


-(NSNumber*)numberWithTheFloatMargin:(CGFloat)margin{
    CGFloat fitMargin = margin * 375 / ViewWidth;
    NSNumber * marginNum = [NSNumber numberWithFloat:fitMargin];
    return marginNum;
}

@end
