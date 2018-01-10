//
//  VerifyBottomTableViewCell.m
//  qunadai
//
//  Created by wang on 17/3/31.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "VerifyBottomTableViewCell.h"

@implementation VerifyBottomTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    self.backgroundColor = grayBackgroundLightColor;
    
    UIButton * checkBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setImage:[UIImage imageNamed:@"quxiaoxuanze"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [checkBtn setContentMode:UIViewContentModeCenter];
    [checkBtn addTarget:self action:@selector(pressToAgreement:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.selected = YES;
    [self.contentView addSubview:checkBtn];
    
    UILabel * agreementLabel= [[UILabel alloc]init];
    agreementLabel.userInteractionEnabled = YES;
    [agreementLabel setFont:QNDFont(12.0)];
    [agreementLabel setTextColor:ThemeColor];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",@"同意",@"《征信查询授权书》以及相关协议"]];
    [str addAttribute:NSForegroundColorAttributeName value:QNDAssistText153Color range:NSMakeRange(0,2)];
    [agreementLabel setAttributedText:str];
    [self.contentView addSubview:agreementLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSeeTheRule:)];
    [agreementLabel addGestureRecognizer:tap];
    
    
    UIButton * verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn setTitle:@"验证" forState:UIControlStateNormal];
    [verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verifyBtn setBackgroundColor:BottomThemeColor];
    [verifyBtn addTarget:self action:@selector(pressToVerify:) forControlEvents:UIControlEventTouchUpInside];
    verifyBtn.layer.cornerRadius = 20;
    verifyBtn.clipsToBounds = YES;
    [self.contentView addSubview:verifyBtn];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkBtn.mas_right).with.offset(2);
        make.top.mas_equalTo(@15);
        make.height.equalTo(@13);
    }];
    
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
        make.height.equalTo(@40);
                            
    }];
}

-(void)pressToAgreement:(UIButton*)button{
    button.selected = !button.selected;
}

-(void)tapToSeeTheRule:(UITapGestureRecognizer*)tap{
    _rBlock();
}

-(void)pressToVerify:(UIButton*)button{
    _vBlcok();
}

@end
