//
//  CPLApplicationResultCell.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLApplicationResultCell.h"


@implementation CPLApplicationResultCell

{
    UIImageView * bgImageV;
    UILabel * descLabel;
    UILabel * tipsLabel;
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
    bgImageV  = [[UIImageView alloc]init];
    [self.contentView addSubview:bgImageV];
    
    descLabel = [[UILabel alloc]init];
    descLabel.font = QNDFont(14);
    descLabel.textColor = black31TitleColor;
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    [self.contentView addSubview:descLabel];
    
    tipsLabel = [[UILabel alloc]init];
    tipsLabel.font = QNDFont(13.0);
    tipsLabel.textColor = ThemeColor;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tipsLabel];
    
    //开始布局
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@25);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.mas_equalTo(self);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@33);
        make.right.equalTo(@-33);
        make.bottom.equalTo(@-48);
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(descLabel);
        make.right.mas_equalTo(descLabel);
        make.bottom.equalTo(@-20);
    }];
}

-(void)setType:(CPLApplicatinType)type andTelNum:(NSString *)tleNum{
    _type = type;
    if (_type == ApplicationReject) {
        [bgImageV setImage:[UIImage imageNamed:@"bg_loan_refuse"]];
        descLabel.text = @"抱歉，您的贷款申请没有通过，可以申请其它产品";
        tipsLabel.text = @"";
    }else if (_type == ApplicationSuccess){
        [bgImageV setImage:[UIImage imageNamed:@"bg_loan_pass"]];
        descLabel.text = @"恭喜您通过审核!";
        
        NSString * tipStr = @"信贷经理将很快联系您";
        if (tleNum.length>0) {
            tipStr = FORMAT(@"信贷经理电话：%@",tleNum);
        }
        tipsLabel.text = tipStr;
    }
}

-(void)setFrame:(CGRect)frame{
    if (frame.size.height>200) {
        frame.size.height -=10;
    }
    [super setFrame:frame];
}


@end
