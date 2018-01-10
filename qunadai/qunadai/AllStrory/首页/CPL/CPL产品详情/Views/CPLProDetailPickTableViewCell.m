//
//  CPLProDetailPickTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLProDetailPickTableViewCell.h"
#import "WHTablePickerVIew.h"

@interface CPLProDetailPickTableViewCell ()

@property (strong,nonatomic)UILabel * valueText;

@property (strong,nonatomic)UILabel * dateText;

@end

@implementation CPLProDetailPickTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    UIView * leftView = [self createViewWithTextField:self.valueText andTitle:@"金额" andFrame:CGRectMake(0, 13, ViewWidth/2, 50)];
    UITapGestureRecognizer * lefttap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheLeftValueView:)];
    [leftView addGestureRecognizer:lefttap];
    [self.contentView addSubview:leftView];
    
    UIView * rightView = [self createViewWithTextField:self.dateText andTitle:@"期限" andFrame:CGRectMake(ViewWidth/2, 13, ViewWidth/2, 50)];
    UITapGestureRecognizer * rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheRightDateView:)];
    [rightView addGestureRecognizer:rightTap];
    [self.contentView addSubview:rightView];
    
}

-(UIView*)createViewWithTextField:(UILabel*)label andTitle:(NSString*)title andFrame:(CGRect)frame{
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor clearColor];
    backView.userInteractionEnabled = YES;
    backView.frame = frame;
    
    [backView addSubview:label];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = ThemeColor;
    [backView addSubview:lineView];
    
    UILabel * descLabel = [[UILabel alloc]init];
    descLabel.font = QNDFont(12.0);
    descLabel.textColor = QNDRGBColor(195, 195, 195);
    descLabel.text = title;
    [backView addSubview:descLabel];
    //开始布局
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.mas_equalTo(backView);
        make.height.equalTo(@30);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).with.offset(0);
        make.centerX.mas_equalTo(backView);
        make.width.equalTo(@80);
        make.height.equalTo(@1);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(backView);
        make.height.equalTo(@13);
        
    }];
    return backView;
}

-(void)setModel:(CPLProductModel *)model{
    _model = model;
    self.valueText.text = FORMAT(@"%ld",_model.max_amount);
    self.dateText.text = FORMAT(@"%ld",_model.max_duration);
}

-(void)tapTheLeftValueView:(UITapGestureRecognizer*)tap{
    @WHWeakObj(self);
    @WHStrongObj(self);
    NSArray * arr;
    if (_model.max_amount>_model.min_amount) {
        arr = @[FORMAT(@"%ld",_model.min_amount),FORMAT(@"%ld",_model.max_amount)];
    }
    else if (_model.min_amount==_model.max_amount){
        arr = @[FORMAT(@"%ld",_model.min_amount)];
    }
    [WHTablePickerView showPickTableWithSouceArr:arr andSelectBlock:^(NSString *selectedStr, NSInteger index) {
        Strongself.valueText.text = selectedStr;
        Strongself.valueB(selectedStr);
    }];
}

-(void)tapTheRightDateView:(UITapGestureRecognizer*)tap{
    @WHWeakObj(self);
    @WHStrongObj(self);
    NSArray * arr;
    if (_model.max_duration>_model.min_duration) {
       arr = @[FORMAT(@"%ld",_model.min_duration),FORMAT(@"%ld",_model.max_duration)];
    }
    else if (_model.min_duration==_model.max_duration){
        arr = @[FORMAT(@"%ld",_model.min_duration)];
    }
    [WHTablePickerView showPickTableWithSouceArr:arr andSelectBlock:^(NSString *selectedStr, NSInteger index) {
        Strongself.dateText.text = selectedStr;
        Strongself.dateB(selectedStr);
    }];

}

-(UILabel *)valueText{
    if (!_valueText) {
        _valueText = [[UILabel alloc]init];
        _valueText.font =QNDFont(21.0);
        _valueText.textColor = ThemeColor;
        _valueText.textAlignment = NSTextAlignmentCenter;
    }
    return _valueText;
}

-(UILabel *)dateText{
    if (!_dateText) {
        _dateText = [[UILabel alloc]init];
        _dateText.font =QNDFont(21.0);
        _dateText.textColor = ThemeColor;
        _dateText.textAlignment = NSTextAlignmentCenter;
    }
    return _dateText;
}

@end
