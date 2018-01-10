//
//  CPLProDetailTopTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLProDetailTopTableViewCell.h"

@interface CPLProDetailTopTableViewCell ()

@property (strong,nonatomic)UILabel * productNameLabel;

@property (strong,nonatomic)UILabel * descLabel;//描述label

@property (strong,nonatomic)UILabel * productvalueLabel; //额度label

@end

@implementation CPLProDetailTopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    
    _productNameLabel = [[UILabel alloc]init];
    _productNameLabel.font = QNDFont(14.0);
    _productNameLabel.textColor = black74TitleColor;
    [self.contentView addSubview:_productNameLabel];
    
    _descLabel = [[UILabel alloc]init];
    _descLabel.font = QNDFont(11.0);
    _descLabel.textColor = QNDRGBColor(195, 195, 195);
    [self.contentView addSubview:_descLabel];
    
    UILabel * valueLabel = [[UILabel alloc]init];
    valueLabel.textColor = QNDRGBColor(195, 195, 195);
    valueLabel.font = QNDFont(14.0);
    valueLabel.text = @"额度范围(元)";
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:valueLabel];
    
    _productvalueLabel = [[UILabel alloc]init];
    _productvalueLabel.font = QNDFont(36);
    _productvalueLabel.textColor = ThemeColor;
    _productvalueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_productvalueLabel];
    
    //开始布局
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@11);
        make.left.equalTo(@12);
        make.height.equalTo(@15);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_productNameLabel.mas_bottom).with.offset(2);
        make.left.mas_equalTo(_productNameLabel);
        make.height.equalTo(@12);
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.equalTo(@-20);
        make.height.equalTo(@15);
    }];
    
    [_productvalueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(valueLabel);
        make.bottom.mas_equalTo(valueLabel.mas_top).with.offset(-18);
        make.height.equalTo(@31);
    }];
}

-(void)setModel:(CPLProductModel *)model{
    _model = model;
    _productNameLabel.text = _model.name;
    _descLabel.text = _model.desc;
    _productvalueLabel.text = FORMAT(@"%ld~%ld",_model.min_amount,model.max_amount);

}

@end
