//
//  QNDDetailProTopTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/9/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDDetailProTopTableViewCell.h"

@implementation QNDDetailProTopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    CGFloat itemWith = (ViewWidth-24)/3;
    
    UIImageView * backView = [[UIImageView alloc]init];
    backView.image = [UIImage imageNamed:@"value_background"];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    UIView * bottomBackView = [[UIView alloc]init];
    bottomBackView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.bottom.equalTo(@-30);
        make.height.equalTo(@36);
    }];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(itemWith, 0, 1, 36)];
    line1.backgroundColor = lightGrayBackColor;
    [bottomBackView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(itemWith*2, 0, 1, 36)];
    line2.backgroundColor = lightGrayBackColor;
    [bottomBackView addSubview:line2];
    
    _productAvatarV = [[UIImageView alloc]init];
    [self.contentView addSubview:_productAvatarV];
    
    _productNameLabel = [[UILabel alloc]init];
    _productNameLabel.font = QNDFont(14.0);
    _productNameLabel.textColor = black31TitleColor;
    [self.contentView addSubview:_productNameLabel];
    
    //星星
    _starView = [[WHStarsView alloc]initWithStarSize:CGSizeMake(10, 10) margin:2 numberOfStars:5];
    _starView.allowSelect = NO;  // 默认可点击
    _starView.allowDecimal = NO;  //默认可显示小数
    _starView.allowDragSelect = NO;//默认不可拖动评分，可拖动下需可点击才有效
    _starView.hidden = YES;
    [self.contentView addSubview:_starView];

    
    UILabel * valueLabel = [[UILabel alloc]init];
    valueLabel.textColor = QNDRGBColor(153, 153, 153);
    valueLabel.font = QNDFont(14.0);
    valueLabel.text = @"最大额度";
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:valueLabel];
    
    _productvalueLabel = [[UILabel alloc]init];
    _productvalueLabel.font = QNDFont(30);
    _productvalueLabel.textColor = ThemeColor;
    _productvalueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_productvalueLabel];
    
    //成功人数
    _productSuccessLabel = [[UILabel alloc]init];
    _productSuccessLabel.font = QNDFont(16.0);
    _productSuccessLabel.textColor = ThemeColor;
    _productSuccessLabel.textAlignment = NSTextAlignmentCenter;
    [bottomBackView addSubview:_productSuccessLabel];
    
    UILabel * termLabel = [[UILabel alloc]init];
    termLabel.text = @"贷款成功";
    termLabel.font = QNDFont(12);
    termLabel.textColor = QNDRGBColor(195, 195, 195);
    termLabel.textAlignment = NSTextAlignmentCenter;
    [bottomBackView addSubview:termLabel];
    
    //利率
    _productRateLabel = [[UILabel alloc]init];
    _productRateLabel.font = QNDFont(16.0);
    _productRateLabel.textColor = ThemeColor;
    _productRateLabel.textAlignment = NSTextAlignmentCenter;
    [bottomBackView addSubview:_productRateLabel];
    
    UILabel * rateLabel = [[UILabel alloc]init];
    rateLabel.text = @"最低利率";
    rateLabel.font = QNDFont(12);
    rateLabel.textColor = QNDRGBColor(195, 195, 195);
    rateLabel.textAlignment =NSTextAlignmentCenter;
    [bottomBackView addSubview:rateLabel];

    
    //放款时间
    _productTimeLabel = [[UILabel alloc]init];
    _productTimeLabel.font = QNDFont(16.0);
    _productTimeLabel.textColor = ThemeColor;
    _productTimeLabel.textAlignment = NSTextAlignmentCenter;
    [bottomBackView addSubview:_productTimeLabel];
    
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"最快放款";
    timeLabel.font = QNDFont(12);
    timeLabel.textColor = QNDRGBColor(195, 195, 195);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [bottomBackView addSubview:timeLabel];
    
    //开始布局
    [_productAvatarV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@12);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_productAvatarV.mas_right).with.offset(6);
        make.centerY.mas_equalTo(_productAvatarV);
        make.height.equalTo(@15);
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_productNameLabel);
        make.top.mas_equalTo(_productNameLabel.mas_bottom).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(60, 10));
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.equalTo(@60);
        make.height.equalTo(@17);
    }];
    
    [_productvalueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(valueLabel);
        make.top.mas_equalTo(valueLabel.mas_bottom).with.offset(10);
        make.height.equalTo(@31);
    }];
    
    //期限布局
    [_productSuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@10);
        make.right.mas_equalTo(line1.mas_left).with.offset(-10);
        make.height.equalTo(@17);
    }];
    
    [termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(_productSuccessLabel);
        make.height.equalTo(@13);
        make.bottom.equalTo(@0);
    }];
    
    // 利率布局
    [_productRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.mas_equalTo(line1.mas_right).with.offset(10);
        make.right.mas_equalTo(line2.mas_left).with.offset(-10);
        make.height.equalTo(@17);
    }];
    
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_productRateLabel);
        make.height.equalTo(@13);
        make.bottom.equalTo(@0);
    }];
    
    //放款时间布局
    [_productTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.mas_equalTo(line2.mas_right).with.offset(10);
        make.right.equalTo(@-10);
        make.height.equalTo(@17);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_productTimeLabel);
        make.height.equalTo(@13);
        make.bottom.equalTo(@0);
    }];

}

-(void)setModel:(productLoanModel *)model{
    _model = model;
    
    [_productAvatarV sd_setImageWithURL:[NSURL URLWithString:model.productLogoUrl] placeholderImage:[UIImage imageNamed:@"default_chanpin"]];
    _productNameLabel.text = _model.productName;

    _productvalueLabel.text = [self getTheMutableStringWithString:FORMAT(@"%ld",_model.amtMax)];
    //借款期限
    _productSuccessLabel.text =  FORMAT(@"%ld人",_model.loanNum);
    //借款利率
    _productRateLabel.attributedText = [model getTheLoanRateStr];
    //放款时间
    _productTimeLabel.text = [model getTheLoanTimeStr];
}


-(NSMutableString*)getTheMutableStringWithString:(NSString*)str{
    //插入逗号
    NSMutableString * finishStr = [NSMutableString stringWithString:str];
    //1.拿出整数部分
    NSArray * arr = [str componentsSeparatedByString:@"."];
    NSString * preStr = arr[0];
    //2.判断长度，是否需要加
    if (preStr.length<4) {
        return finishStr;
        //依然用firstStr
    }else if (preStr.length<7){
        //需要加入一个逗号
        [finishStr insertString:@"," atIndex:preStr.length-3];
        return finishStr;
    }else if (preStr.length<10){
        //需要加入两个逗号
        [finishStr insertString:@"," atIndex:preStr.length-6];
        [finishStr insertString:@"," atIndex:preStr.length-3+1];
        return finishStr;
    }else{
        return finishStr;
    }
}

@end
