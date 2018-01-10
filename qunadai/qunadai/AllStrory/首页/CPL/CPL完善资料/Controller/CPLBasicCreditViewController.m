//
//  CPLBasicCreditViewController.m
//  qunadai
//
//  Created by wang on 2017/11/2.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#define KTextFieldMargin 20

#import "CPLBasicCreditViewController.h"
#import "CPLExtraCreditViewController.h"

#import "WHVerify.h"
#import "CPLUserCreditModel.h"

#import "JFLocation.h"

#import "CPLUserInfoGetApi.h"
#import "QNDLocationPostApi.h"

#import "CPLProgressView.h"
#import "WHTablePickerVIew.h"

@interface CPLBasicCreditViewController ()<UIScrollViewDelegate,JFLocationDelegate>

@property (strong,nonatomic)UIScrollView * mainScroller;

@property (strong,nonatomic)UITextField * nameField;

@property (strong,nonatomic)UITextField * IdCardField;

@property (strong,nonatomic)UITextField * WXNumField;

@property (strong,nonatomic)UITextField * QQNumField;

@property (strong,nonatomic)UILabel * educationLabel;//学历

@property (strong,nonatomic)CPLProgressView * progressView;

@property (strong,nonatomic)UIButton * nextStepBtn;//下一步

@property (strong,nonatomic)CPLUserCreditModel * model;//用户信息model

@property (strong,nonatomic)JFLocation * locationManager;

@end

@implementation CPLBasicCreditViewController
{
    NSMutableDictionary * attrs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NOTIF_ADD(UIKeyboardWillChangeFrameNotification, keyboardWillChange:);
    NOTIF_ADD(UITextFieldTextDidChangeNotification, textFieldDidChanged:);
    [self layoutViews];
    [self setupLocation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [TalkingData trackPageEnd:@"完善基本信息"];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"完善信息";
    [self setupData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"完善基本信息"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NOTIF_REMVWITHNAME(UITextFieldTextDidChangeNotification);
        NOTIF_REMVWITHNAME(UIKeyboardWillChangeFrameNotification);
    } @catch (NSException *exception) {
    } @finally {
    }
}

-(void)setupLocation{
    self.locationManager = [[JFLocation alloc]init];
    self.locationManager.delegate = self;
}

-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainScroller = [[UIScrollView alloc]init];
    [_mainScroller setFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64)];
    _mainScroller.backgroundColor = [UIColor whiteColor];
    _mainScroller.showsVerticalScrollIndicator = NO;
    _mainScroller.contentSize = CGSizeMake(ViewWidth, ViewHeight-64+1);
    _mainScroller.delegate = self;
    _mainScroller.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_mainScroller];
    
    _progressView = [[CPLProgressView alloc]initWithFinishStep:BasicInfoFinish andFrame:CGRectMake(0, 0, ViewWidth, 100)];
    [_mainScroller addSubview:_progressView];
    
    UIImageView * lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_progressView.frame)+35, 7, 224)];
    [lineImageV setImage:[UIImage imageNamed:@"mes_color_one"]];
    [_mainScroller addSubview:lineImageV];
    
    attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(15.0);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    
    UIView * view1 = [self setUpViewForTextFieldWith:@"姓名" andTextField:self.nameField andFrame:CGRectMake(45, CGRectGetMaxY(_progressView.frame)+30, ViewWidth-90, 35)];
    [_mainScroller addSubview:view1];
    
    UIView * view2 = [self setUpViewForTextFieldWith:@"身份证" andTextField:self.IdCardField andFrame:CGRectMake(45,        CGRectGetMaxY(view1.frame)+KTextFieldMargin, ViewWidth-90, 35)];
    [_mainScroller addSubview:view2];
    
    UIView * view3 = [self setUpViewForTextFieldWith:@"微信号" andTextField:self.WXNumField andFrame:CGRectMake(45, CGRectGetMaxY(view2.frame)+KTextFieldMargin, ViewWidth-90, 35)];
    [_mainScroller addSubview:view3];
    
    UIView * view4 = [self setUpViewForTextFieldWith:@"QQ号" andTextField:self.QQNumField andFrame:CGRectMake(45, CGRectGetMaxY(view3.frame)+KTextFieldMargin, ViewWidth-90, 35)];
    [_mainScroller addSubview:view4];
    
    UIView * view5 = [self setupViewForSelectdLabel:@"学历" andLabel:self.educationLabel andFrame:CGRectMake(45, CGRectGetMaxY(view4.frame)+KTextFieldMargin, ViewWidth-90, 35)];
    view5.userInteractionEnabled = YES;
    [_mainScroller addSubview:view5];
    //添加点击事件
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelectTheEducation:)];
    [view5 addGestureRecognizer:tap];
    
    //底部下一步的btn
    [self.nextStepBtn setFrame:CGRectMake(20, CGRectGetMaxY(view5.frame)+45, ViewWidth-40, 40)];
    [_mainScroller addSubview:self.nextStepBtn];
    //如果屏幕比例为ipad
    if (CGRectGetMaxY(self.nextStepBtn.frame)+20 > ViewHeight-64+1) {
        _mainScroller.contentSize = CGSizeMake(ViewWidth, CGRectGetMaxY(self.nextStepBtn.frame)+22);
    }
}


//创建选择框

-(UIView*)setupViewForSelectdLabel:(NSString*)labelStr andLabel:(UILabel*)selectLabel andFrame:(CGRect)frame{
    UIView * backView = [[UIView alloc]initWithFrame:frame];
    backView.backgroundColor = [UIColor clearColor];
    
    UILabel * leftLabel = [[UILabel alloc]init];
    leftLabel.font = QNDFont(14.0);
    leftLabel.textColor = QNDRGBColor(181, 188, 204);
    leftLabel.text = labelStr;
    [backView addSubview:leftLabel];
    
    [backView addSubview:self.educationLabel];
    
    UIView * bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = QNDRGBColor(242, 242, 242);
    [backView addSubview:bottomLine];
    
    UIImageView * moreView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mes_icon_more"]];
    [backView addSubview:moreView];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.equalTo(@15);
        make.width.equalTo(@50);
    }];
    
    [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftLabel);
        make.left.mas_equalTo(leftLabel.mas_right).with.offset(20);
        make.height.equalTo(@30);
        make.right.equalTo(@-20);
    }];
    
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftLabel);
        make.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    return backView;
}
//创建输入框
-(UIView*)setUpViewForTextFieldWith:(NSString*)labelStr andTextField:(UITextField*)textfield andFrame:(CGRect)frame{
    UIView * backView = [[UIView alloc]initWithFrame:frame];
    backView.backgroundColor = [UIColor clearColor];
    
    UILabel * leftLabel = [[UILabel alloc]init];
    leftLabel.font = QNDFont(14.0);
    leftLabel.textColor = QNDRGBColor(181, 188, 204);
    leftLabel.text = labelStr;
    [backView addSubview:leftLabel];
    
    [backView addSubview:textfield];
    
    UIView * bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = QNDRGBColor(242, 242, 242);
    [backView addSubview:bottomLine];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.equalTo(@15);
        make.width.equalTo(@50);
    }];
    
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftLabel);
        make.left.mas_equalTo(leftLabel.mas_right).with.offset(20);
        make.height.equalTo(@30);
        make.right.equalTo(@-20);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    return backView;
}

#pragma mark- 数据请求
-(void)setupData{
    CPLUserInfoGetApi * api = [[CPLUserInfoGetApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

#pragma mark - 点击下一步
-(void)pressToNextStep:(UIButton*)button{
    [TalkingData trackEvent:@"个人信息" label:@"个人信息"];
    CPLExtraCreditViewController * extraVC = [[CPLExtraCreditViewController alloc]init];
    extraVC.model = self.model;
    [self.navigationController pushViewController:extraVC animated:YES];
}

#pragma mark - 点击选择教育程度
-(void)tapToSelectTheEducation:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
    NSArray * arr = @[@"硕士及以上",@"本科",@"大专",@"中专/高中及以下"];
    @WHWeakObj(self);
    @WHStrongObj(self);
    [WHTablePickerView showPickTableWithSouceArr:arr andSelectBlock:^(NSString *selectedStr,NSInteger index) {
        Strongself.educationLabel.text = selectedStr;
        Strongself.model.education_type = index + 1;
        [Strongself checkTheInfo];
    }];
}

#pragma mark- 监控textField的输入内容
-(void)textFieldDidChanged:(NSNotification*)noc{
    [self checkTheInfo];
}

-(void)checkTheInfo{
    BOOL isSuccess = YES;
    if (![WHVerify checkUserName:self.nameField.text]) {
        isSuccess = NO;
    }
    if (![WHVerify checkUserIdCard:self.IdCardField.text]) {
        isSuccess = NO;
    }
    if (self.WXNumField.text.length<6) {
        isSuccess = NO;
    }
    if (self.QQNumField.text.length<6) {
        isSuccess = NO;
    }
    if (self.educationLabel.text.length<2) {
        isSuccess = NO;
    }
    self.nextStepBtn.backgroundColor = isSuccess ? ThemeColor : QNDRGBColor(195, 195, 195);
    self.nextStepBtn.userInteractionEnabled = isSuccess;
    if (isSuccess) {
        self.model.name = self.nameField.text;
        self.model.idcard_number = self.IdCardField.text;
        self.model.wechat_number = self.WXNumField.text;
        self.model.qq_number = self.QQNumField.text;
    }
}

-(UITextField *)nameField{
    if (!_nameField) {
        _nameField = [[UITextField alloc]init];
        _nameField.font =QNDFont(14.0);
        _nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入真实姓名" attributes:attrs];
        _nameField.textColor = black74TitleColor;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.tintColor = ThemeColor;
    }
    return _nameField;
}

-(UITextField *)IdCardField{
    if (!_IdCardField) {
        _IdCardField = [[UITextField alloc]init];
        _IdCardField.font =QNDFont(14.0);
        _IdCardField.textColor = black74TitleColor;
        _IdCardField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入身份证号码" attributes:attrs];
        _IdCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _IdCardField.tintColor = ThemeColor;
    }
    return _IdCardField;
}

-(UITextField *)WXNumField{
    if (!_WXNumField) {
        _WXNumField = [[UITextField alloc]init];
        _WXNumField.font =QNDFont(14.0);
        _WXNumField.textColor = black74TitleColor;
        _WXNumField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入微信号" attributes:attrs];
        _WXNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _WXNumField.tintColor = ThemeColor;
    }
    return _WXNumField;
}

-(UITextField *)QQNumField{
    if (!_QQNumField) {
        _QQNumField = [self createTextFieldWithPlaceholder:@"请输入QQ号"];
    }
    return _QQNumField;
}

-(UITextField  *)createTextFieldWithPlaceholder:(NSString*)placehodler{
    UITextField * textField = [[UITextField alloc]init];
    textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placehodler attributes:attrs];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.tintColor = ThemeColor;
    textField.textColor = black74TitleColor;
    textField.font = QNDFont(14.0);
    return textField;
}

-(UILabel *)educationLabel{
    if (!_educationLabel) {
        _educationLabel = [[UILabel alloc]init];
        _educationLabel.font = QNDFont(14.0);
        _educationLabel.textColor = black74TitleColor;
    }
    return _educationLabel;
}

-(UIButton *)nextStepBtn{
    if (!_nextStepBtn) {
        _nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepBtn.backgroundColor = QNDRGBColor(195, 195, 195);
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepBtn.titleLabel setFont:QNDFont(18)];
        _nextStepBtn.layer.cornerRadius = 20;
        _nextStepBtn.clipsToBounds = YES;
        _nextStepBtn.userInteractionEnabled = NO;
        [_nextStepBtn addTarget:self action:@selector(pressToNextStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepBtn;
}

-(CPLUserCreditModel *)model{
    if (!_model) {
        _model = [[CPLUserCreditModel alloc]init];
    }
    return _model;
}

#pragma mark-键盘相关
- (void)keyboardWillChange:(NSNotification *)note
{
    if ([self.nameField isFirstResponder]||[self.IdCardField isFirstResponder] ) {
        return;
    }
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - ViewHeight;
    if (keyFrame.origin.y>ViewHeight) {
        moveY = keyFrame.origin.y-ViewHeight;
    }
    if (moveY<0) {
        moveY += 100;
    }
    WHLog(@"moveF==%f",moveY);
    [UIView animateWithDuration:duration animations:^{
        self.mainScroller.transform=CGAffineTransformMakeTranslation(0, moveY);
    }];
}

#pragma mark-定位相关delegate
//定位中
- (void)locating {
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    //将位置上传至后台
    WHLog(@"%@",locationDictionary);
    NSString * State = [locationDictionary valueForKey:@"State"];//省
    NSString *city = [locationDictionary valueForKey:@"City"];//市
    NSString * subLocality = [locationDictionary valueForKey:@"SubLocality"];//区
    if (!State) {
        State = city;
    }
    NSString * locationStr = FORMAT(@"%@/%@/%@",State,city,subLocality);
    [self sendTheLocationWithLocationStr:locationStr];
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    WHLog(@"%@",message);
    @WHWeakObj(self);
    [[WHTool shareInstance]showAlterViewWithTitle:@"请打开定位功能" Message:message cancelBtn:@"不获取新口子" doneBtn:@"获取最新口子"andVC:self andDoneBlock:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
            [[UIApplication sharedApplication] openURL:settingUrl];
        }
    } andCancelBlock:^(UIAlertAction * _Nonnull action) {
        [Weakself.navigationController popToRootViewControllerAnimated:YES];
    }];
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    WHLog(@"%@",message);
}

-(void)sendTheLocationWithLocationStr:(NSString*)locationStr{
    QNDLocationPostApi * api = [[QNDLocationPostApi alloc]initWithLocationString:locationStr];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}


@end
