//
//  QNDValueTopTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/9/12.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDValueTopTableViewCell.h"
#import "NSString+extention.h"

@implementation QNDValueTopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = lightGrayBackColor;
    [self.contentView addSubview:lineView];
    
    UILabel * predictLabel = [[UILabel alloc]init];
    predictLabel.font = QNDFont(14.0);
    predictLabel.textColor = QNDRGBColor(195, 195, 195);
    predictLabel.text = @"预估额度";
    predictLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:predictLabel];
    
    _valueLabel = [[UILabel alloc]init];
    _valueLabel.font = QNDFont(40.0);
    _valueLabel.textColor = ThemeColor;
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.text = @"500";
    [self.contentView addSubview:_valueLabel];
    
    UILabel * tipsLabel = [[UILabel alloc]init];
    tipsLabel.font = QNDFont(12.0);
    tipsLabel.textColor = QNDRGBColor(238, 100, 43);
    tipsLabel.text = @"完善信息获取更高额度";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.alpha = 0.5;
    [self.contentView addSubview:tipsLabel];

    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.centerX.mas_equalTo(self);
        make.height.equalTo(@13);
    }];
    
    [predictLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(tipsLabel.mas_top).with.offset(-15);
        make.height.equalTo(@15);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(predictLabel.mas_top).with.offset(-5);
        make.height.equalTo(@41);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0.5);
        make.size.mas_equalTo(CGSizeMake(43, 0.5));
    }];
}

-(void)setTheLoanValue:(NSString *)value{
    _valueLabel.text = [NSString getTheMutableStringWithString:value];
}



@end
