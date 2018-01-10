//
//  CalculaterViewController.m
//  qunadai
//
//  Created by wang on 2017/8/8.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "CalculaterViewController.h"

@interface CalculaterViewController ()
{
    UIView * topView;
    UIView * bottomView;
    
    NSString * resultStr;//计算结果
}
@property(strong,nonatomic)UITextField * rateText;

@property(strong,nonatomic)UITextField * moneyText;//借款金额

@property(strong,nonatomic)UITextField * dateText;//借款期限

@property(strong,nonatomic)UILabel * finalLabel;//最后应还的显示label

@end

@implementation CalculaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    resultStr = @"0";
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0];
    self.title = @"贷款计算器";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    self.view.backgroundColor = grayBackgroundLightColor;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheView)];
    [self.view addGestureRecognizer:tap];
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(7, 10+64, ViewWidth-14, 204)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 5;
    topView.clipsToBounds = YES;
    [self.view addSubview:topView];
    
    UILabel * topLabel = [self createLabelWithTitle:@"借多少(元)："];
    UILabel * midLabel = [self createLabelWithTitle:@"借多久(年)："];
    UILabel * bottomLabel = [self createLabelWithTitle:@"借款利率："];
    [topView addSubview:topLabel];
    [topView addSubview:midLabel];
    [topView addSubview:bottomLabel];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@35);
        make.left.equalTo(@12);
        make.size.mas_equalTo(CGSizeMake(95, 17));
    }];
    
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView);
        make.left.mas_equalTo(topLabel);
        make.size.mas_equalTo(topLabel);
    }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-35);
        make.left.mas_equalTo(topLabel);
        make.size.mas_equalTo(topLabel);
    }];
    
    [self.moneyText setFrame:CGRectMake(108, 24, ViewWidth-24-118, 36)];
    [self.dateText setFrame:CGRectMake(108, CGRectGetMaxY(self.moneyText.frame)+25, self.moneyText.width, self.moneyText.height)];
    [self.rateText setFrame:CGRectMake(108, CGRectGetMaxY(self.dateText.frame)+25, self.moneyText.width, self.moneyText.height)];
    
    [topView addSubview:self.moneyText];
    [topView addSubview:self.dateText];
    [topView addSubview:self.rateText];
    
    [self createBtns];
    [self createBottomView];
}

-(void)createBtns{
    UIButton * calculateBtn = [self createBtnWithTitle:@"计算"];
    [calculateBtn addTarget:self action:@selector(calculaterTheData:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * cleanBtn = [self createBtnWithTitle:@"重置"];
    [cleanBtn addTarget:self action:@selector(cleanAllTheData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calculateBtn];
    [self.view addSubview:cleanBtn];
    
    [calculateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13);
        make.top.mas_equalTo(topView.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake((ViewWidth-42)/2, 40));
    }];
    
    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-13);
        make.top.mas_equalTo(calculateBtn);
        make.size.mas_equalTo(calculateBtn);
    }];
}


-(void)createBottomView{
    if (bottomView) {
        [bottomView removeAllSubviews];
    }
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(7, CGRectGetMaxY(topView.frame)+80, ViewWidth-14, 70)];
    bottomView.layer.cornerRadius = 5;
    bottomView.clipsToBounds = YES;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    _finalLabel = [[UILabel alloc]init];
    _finalLabel.font = QNDFont(14.0);
    _finalLabel.textColor = QNDAssistText153Color;

    NSMutableString * finishStr = [NSMutableString stringWithFormat:@"每月需还款：%@ 元",resultStr];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:finishStr];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(25);
    attrs[NSForegroundColorAttributeName] = BottomThemeColor;
    
    NSRange rang = [finishStr rangeOfString:resultStr];
    [attrStr addAttributes:attrs range:rang];
    
    _finalLabel.attributedText = attrStr;
    
    [bottomView addSubview:_finalLabel];
    
    [_finalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bottomView);
        make.height.equalTo(@30);
    }];
}

-(UILabel *)createLabelWithTitle:(NSString*)title{
    UILabel * label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = black74TitleColor;
    label.font = QNDFont(16.0);
    return label;
}

-(UIView*)createTextViewWithFrame:(CGRect)frame{
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.borderColor = lightGrayBackColor.CGColor;
    backView.layer.borderWidth = 1;
    backView.clipsToBounds = YES;
    [backView setFrame:frame];
    
    UIImageView * iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"calculater_arrow"];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-14);
        make.centerY.mas_equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(15, 8));
    }];
    return backView;
}

-(UIButton*)createBtnWithTitle:(NSString*)title{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:QNDFont(17.0)];
    btn.layer.cornerRadius = 20;
    btn.clipsToBounds = YES;
    return btn;
}


-(UITextField *)rateText{
    if (!_rateText) {
        _rateText = [self createTextFieldWithPleaceHolder:@"请输入月利率" andRightLabelStr:@" %"];
    }
    return _rateText;
}

-(UITextField*)moneyText{
    if (!_moneyText) {
        _moneyText = [self createTextFieldWithPleaceHolder:@"请输入借款金额" andRightLabelStr:@"  ¥"];
    }
    return _moneyText;
}

-(UITextField *)dateText{
    if (!_dateText) {
        _dateText = [self createTextFieldWithPleaceHolder:@"请输入借款期限" andRightLabelStr:@" 月"];
    }
    return _dateText;
}

-(UITextField*)createTextFieldWithPleaceHolder:(NSString*)holder andRightLabelStr:(NSString*)string{
    UITextField * text = [[UITextField alloc]init];
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(15.0);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    text.attributedPlaceholder = [[NSAttributedString alloc]initWithString:holder attributes:attrs];
    text.textAlignment = NSTextAlignmentCenter;
    text.keyboardType = UIKeyboardTypeNumberPad;
    text.tintColor = ThemeColor;
    text.font = QNDFont(16.0);
    text.rightViewMode = UITextFieldViewModeAlways;
    text.layer.cornerRadius = 5;
    text.layer.borderColor = defaultGrayBackGroundColor.CGColor;
    text.layer.borderWidth = 0.5;
    text.clipsToBounds = YES;
    
    UILabel * unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 15)];
    unitLabel.font = QNDFont(14.0);
    unitLabel.textColor = black74TitleColor;
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.text = string;
    [text setRightView:unitLabel];
    return text;
}

#pragma mark- 点击事件

-(void)cleanAllTheData:(UIButton*)btn{
    self.moneyText.text = nil;
    self.dateText.text = nil;
    self.rateText.text = nil;
    resultStr = @"0";
    [self createBottomView];
    [self.view endEditing:YES];
}

-(void)calculaterTheData:(UIButton*)btn{
    //    月还款额=（借款金额/借款期限）+（借款金额*月利率）
    //    月利率 = 日利率 * 30;
    CGFloat loanMoney = [_moneyText.text floatValue];
    CGFloat loanDate = [_dateText.text floatValue];
    CGFloat loanRate = [_rateText.text floatValue]/100;
    CGFloat final = (loanMoney/loanDate)+(loanMoney*loanRate);
    
    resultStr = [NSString stringWithFormat:@"%.2f",final];
    [self createBottomView];
}

-(void)tapTheView{
    [self.view endEditing:YES];
}



@end
