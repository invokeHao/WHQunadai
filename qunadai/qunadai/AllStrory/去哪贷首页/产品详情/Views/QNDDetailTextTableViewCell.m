//
//  QNDDetailTextTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/9/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDDetailTextTableViewCell.h"

@implementation QNDDetailTextTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    UILabel * successLabel = [self setupLeftLabelWithTitle:@"通过率："];
    [self.contentView addSubview:successLabel];
    
    _successRateLabel = [self setupLabelRightLabel];
    [self.contentView addSubview:_successRateLabel];
    
    UILabel * passLabel = [self setupLeftLabelWithTitle:@"贷款成功："];
    [self.contentView addSubview:passLabel];
    
    _passAmountLabel = [self setupLabelRightLabel];
    [self.contentView addSubview:_passAmountLabel];
    
    UILabel * avglabel = [self setupLeftLabelWithTitle:@"平均放款金额："];
    [self.contentView addSubview:avglabel];
    
    _avgValueLabel = [self setupLabelRightLabel];
    [self.contentView addSubview:_avgValueLabel];
    //开始布局
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@12);
        make.height.equalTo(@15);
    }];
    
    [_successRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.top.equalTo(@11);
        make.height.equalTo(@17);
    }];
    
    [passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.mas_equalTo(successLabel.mas_bottom).with.offset(12);
        make.height.equalTo(@15);
    }];
    
    [_passAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(passLabel);
        make.height.equalTo(@17);
    }];
    
    [avglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.mas_equalTo(passLabel.mas_bottom).with.offset(12);
        make.height.equalTo(@15);
    }];
    
    [_avgValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(avglabel);
        make.height.equalTo(@17);
    }];
}

-(void)setModel:(productLoanModel *)model{
    _model = model;
    NSString * rateStr = FORMAT(@"%ld",_model.loanRate);
    _successRateLabel.text = [rateStr stringByAppendingString:@"%"];
    _passAmountLabel.text = FORMAT(@"%ld人",_model.loanNum);
    NSInteger avg = (_model.amtMax+_model.amtMin)/2;
    _avgValueLabel.text = FORMAT(@"%ld元",avg);
}

-(UILabel *)setupLeftLabelWithTitle:(NSString*)title{
    UILabel * label = [[UILabel alloc]init];
    label.font = QNDFont(14.0);
    label.textColor = QNDRGBColor(109, 109, 109);
    label.text = title;
    return label;
}

-(UILabel*)setupLabelRightLabel{
    UILabel * label = [[UILabel alloc]init];
    label.font = QNDFont(16.0);
    label.textColor = black74TitleColor;
    return label;
}

@end
