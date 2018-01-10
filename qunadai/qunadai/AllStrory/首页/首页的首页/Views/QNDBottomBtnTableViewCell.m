//
//  QNDBottomBtnTableViewCell.m
//  qunadai
//
//  Created by 王浩 on 2017/12/28.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDBottomBtnTableViewCell.h"

@implementation QNDBottomBtnTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews{
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.backgroundColor = ThemeColor;
    [bottomBtn setTitle:@"完善信息 立即提现" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn.titleLabel setFont:QNDFont(16.0)];
    [bottomBtn addTarget:self action:@selector(pressToFinishInfo:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.layer.cornerRadius = 2;
    bottomBtn.clipsToBounds = YES;
    [self.contentView addSubview:bottomBtn];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@40);
    }];
}


-(void)pressToFinishInfo:(UIButton*)button{
    _block();
}
@end
