//
//  QNDPickValueViewController.m
//  qunadai
//
//  Created by wang on 2017/9/25.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDPickValueViewController.h"
#import "QNDLoanSuccessViewController.h"

#import "QNDDetialTopView.h"

#import "QNDProductPVCollectApi.h"


@interface QNDPickValueViewController ()<UIScrollViewDelegate>

@property (strong,nonatomic)UIScrollView * mainScroller;

@property (strong,nonatomic)QNDDetialTopView * midBackView;

@property (strong,nonatomic)UISlider * valueSlider;

@property (strong,nonatomic)UISlider * timeSlider;

@end

@implementation QNDPickValueViewController
{
    UILabel * valueLabel;//利率label
    UILabel * monthLabel;//每月还款label
    NSInteger payValue;
    NSInteger payMonth;
    UIView * planView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"借款";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)layoutViews{
    payMonth = 12;
    payValue = 1000;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mainScroller = [[UIScrollView alloc]init];
    [_mainScroller setFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64)];
    _mainScroller.backgroundColor = [UIColor whiteColor];
    _mainScroller.showsVerticalScrollIndicator = NO;
    _mainScroller.contentSize = CGSizeMake(ViewWidth, ViewHeight-64+1);
    _mainScroller.delegate = self;
    [self.view addSubview:_mainScroller];
    
    _midBackView = [[QNDDetialTopView alloc]initWithValueStr:_loanvalueStr];
    _midBackView.backgroundColor = [UIColor whiteColor];
    [_midBackView setFrame:CGRectMake(0, 0, ViewWidth, 273)];
    [self.mainScroller addSubview:_midBackView];
    
    [self setupLoanPlanView];
    [self setupBottomBtn];
}

-(void)setupLoanPlanView{
    planView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_midBackView.frame)+20, ViewWidth, 140)];
    planView.backgroundColor = [UIColor clearColor];
    [_mainScroller addSubview:planView];
    
    UIImageView * titleView = [[UIImageView alloc]init];
    [titleView setImage:[UIImage imageNamed:@"red_bg"]];
    [planView addSubview:titleView];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"借款计划";
    [titleLabel setFont:QNDFont(14.0)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleView addSubview:titleLabel];

    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(70, 22));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(titleView);
        make.height.equalTo(@15);
    }];

    UILabel * loanLabel = [[UILabel alloc]init];
    loanLabel.font = QNDFont(16.0);
    loanLabel.textColor = QNDRGBColor(185, 185, 185);
    loanLabel.text = @"借款金额";
    [planView addSubview:loanLabel];
    [planView addSubview:self.valueSlider];
    
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.font = QNDFont(16.0);
    timeLabel.textColor = QNDRGBColor(185, 185, 185);
    timeLabel.text = @"借款时间";
    [planView addSubview:timeLabel];
    [planView addSubview:self.timeSlider];
    
    [loanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.mas_equalTo(titleView.mas_bottom).with.offset(35);
        make.height.equalTo(@17);
    }];
    [_valueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loanLabel.mas_right).with.offset(12);
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(loanLabel);
        make.height.equalTo(@22);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.mas_equalTo(loanLabel.mas_bottom).with.offset(35);
        make.height.equalTo(@17);
    }];
    [_timeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeLabel.mas_right).with.offset(12);
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(timeLabel);
        make.height.equalTo(@22);
    }];
    //设置显示值的label
    valueLabel = [[UILabel alloc]init];
    valueLabel.font = QNDFont(15.0);
    valueLabel.textColor = ThemeColor;
    valueLabel.text = @"1000元";
    [planView addSubview:valueLabel];
    
    monthLabel = [[UILabel alloc]init];
    monthLabel.font = QNDFont(15.0);
    monthLabel.textColor = ThemeColor;
    monthLabel.text = @"1个月";
    [planView addSubview:monthLabel];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_valueSlider.mas_left).with.offset(-10);
        make.bottom.mas_equalTo(_valueSlider.mas_top).with.offset(-5);
        make.height.equalTo(@16);
    }];
    [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeSlider.mas_left).with.offset(-10);
        make.bottom.mas_equalTo(_timeSlider.mas_top).with.offset(-5);
        make.height.equalTo(@16);
    }];
}

-(void)setupBottomBtn{
    UIButton * loanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loanBtn setFrame:CGRectMake(12, CGRectGetMaxY(planView.frame)+50, ViewWidth-24, 46)];
    [loanBtn setTitle:@"立即借款" forState:UIControlStateNormal];
    [loanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loanBtn.titleLabel setFont:QNDFont(18)];
    loanBtn.backgroundColor = ThemeColor;
    loanBtn.layer.cornerRadius = 2;
    loanBtn.clipsToBounds = YES;
    [loanBtn addTarget:self action:@selector(pressTheLoanBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroller addSubview:loanBtn];
    //如果屏幕比例为ipad
    if (CGRectGetMaxY(loanBtn.frame)+50 > ViewHeight-64+1) {
        _mainScroller.contentSize = CGSizeMake(ViewWidth, CGRectGetMaxY(loanBtn.frame)+52);
    }
}

-(void)pressTheLoanBtn:(UIButton*)button{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    NSString * productCode = @"";
    QNDProductPVCollectApi * api = [[QNDProductPVCollectApi alloc]initProductCode:productCode andPVType:QNDApplicateType];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [[request responseJSONObject][@"status"]integerValue];
        if (status!=1) {
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
        WHLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

-(void)sliderValueChanged:(UISlider*)slider{
    if (slider==self.valueSlider) {
        //计算lable的坐标
        CGFloat totalX = slider.maximumValue - slider.minimumValue;
        CGFloat X = (slider.width-30) * (slider.value-1000)/totalX;
        if (X==slider.width-30) {
            X -= 14;
        }
        NSNumber * leftNum = [NSNumber numberWithFloat:X+80];
        //判断是否改变金额
        payValue = roundf(slider.value/1000)*1000;
        valueLabel.text = FORMAT(@"%ld元",payValue);
        [valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftNum);
            make.bottom.mas_equalTo(_valueSlider.mas_top).with.offset(-5);
            make.height.equalTo(@16);
        }];
        if (slider.value==self.valueSlider.minimumValue) {
            self.valueSlider.minimumTrackTintColor = [UIColor clearColor];
        }else{
            self.valueSlider.minimumTrackTintColor = ThemeColor;
        }
    }else if (slider==self.timeSlider){
        //计算lable的坐标
        CGFloat totalX = slider.maximumValue - slider.minimumValue;
        CGFloat X = (slider.width-30) * (slider.value-1)/totalX;
        NSNumber * leftNum = [NSNumber numberWithFloat:X+82];
            //判断是否改变金额
        payMonth = roundf(slider.value);
        monthLabel.text = FORMAT(@"%ld个月",payMonth);
        [monthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftNum);
            make.bottom.mas_equalTo(_timeSlider.mas_top).with.offset(-5);
            make.height.equalTo(@16);
        }];
        if (slider.value==self.timeSlider.minimumValue) {
            self.timeSlider.minimumTrackTintColor = [UIColor clearColor];
        }else{
            self.timeSlider.minimumTrackTintColor = ThemeColor;
        }
    }
    //计算每月应还金额
    CGFloat payNum = (payValue*0.0078+payValue)/payMonth;
    self.midBackView.payMonthLabel.text = FORMAT(@"每月还款%.2f",payNum);
}

-(UISlider *)valueSlider{
    if (!_valueSlider) {
        _valueSlider = [[UISlider alloc]init];
        _valueSlider.minimumValue = 1000;
        _valueSlider.maximumValue = [_loanvalueStr floatValue];
        [_valueSlider setThumbImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
        _valueSlider.minimumTrackTintColor = [UIColor clearColor];
        _valueSlider.maximumTrackTintColor = QNDRGBColor(242, 242, 242);
        _valueSlider.continuous = YES;
        [_valueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _valueSlider;
}

-(UISlider *)timeSlider{
    if (!_timeSlider) {
        _timeSlider = [[UISlider alloc]init];
        _timeSlider.minimumValue = 1;
        _timeSlider.maximumValue = 12;
        _timeSlider.minimumTrackTintColor = [UIColor clearColor];
        _timeSlider.maximumTrackTintColor = QNDRGBColor(242, 242, 242);
        [_timeSlider setThumbImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
        [_timeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _timeSlider;
}



@end
