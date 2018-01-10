//
//  VerifyCodeViewController.m
//  qunadai
//
//  Created by wang on 2017/9/6.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDVerifyCodeViewController.h"
#import "QNDCreatePasswordViewController.h"

#import "CPLLonginApi.h"
#import "QNDPhoneCodeVerifyApi.h"

#import "NSTimer+WHTool.h"

#import "WHVerify.h"
#import "NSString+extention.h"

@interface QNDVerifyCodeViewController ()<UITextFieldDelegate,YTKChainRequestDelegate>

@property (strong,nonatomic)UITextField * codeField;//验证码输入框

@property (strong,nonatomic) NSTimer * delayTimer; //心跳

@end

@implementation QNDVerifyCodeViewController
{
    int countTime;//计数
    UILabel * _secondLabel;//显示倒计时的label
    UIImageView * checkView;
    UIButton * nextBtn;//下一步
    UIButton * reGetBtn;//重新获取验证码
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTouch];
    //进入页面后发送验证码
    [self getTheVerifyCode];
    [self layoutViews];
    NOTIF_ADD(UITextFieldTextDidChangeNotification, textFieldDidChanged:);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)dealloc{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        NOTIF_REMVWITHNAME(UITextFieldTextDidChangeNotification);
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    //返回按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeLeft];
    [backBtn setFrame:CGRectMake(10, 30, 40, 30)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
    [backBtn addTarget:self action:@selector(backToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel * themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 74, 210, 31)];
    [themeLabel setFont:QNDFont(30)];
    [themeLabel setTextColor:blackTitleColor];
    [themeLabel setText:@"输入4位验证码"];
    [self.view addSubview:themeLabel];
    
    UILabel * descLabel = [[UILabel alloc]init];
    descLabel.font = QNDFont(14.0);
    descLabel.text = FORMAT(@"我们已向%@发送了一条4位数的短信验证码，请在消息框中输入",_mobileNumber);
    descLabel.textColor = QNDRGBColor(210, 210, 210);
    descLabel.numberOfLines = 0;
    [self.view addSubview:descLabel];
    
    [self.view addSubview:self.codeField];
    
    //下一步按钮
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(0, 0, ViewWidth-60, 40)];
    NSString * btnTitle = @"下一步";
    if (_apiType == smsLogin) {
        btnTitle = @"登录";
    }
    [nextBtn setTitle:btnTitle forState:UIControlStateNormal];

    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:grayBackgroundLightColor];
    [nextBtn.titleLabel setFont:QNDFont(18.0)];
    [nextBtn addTarget:self action:@selector(nextStepTodo:) forControlEvents:
     UIControlEventTouchUpInside];
    [nextBtn setUserInteractionEnabled:NO];
    nextBtn.layer.cornerRadius = 2;
    nextBtn.clipsToBounds=YES;
    [self.view addSubview:nextBtn];

    reGetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reGetBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    [reGetBtn.titleLabel setFont:QNDFont(16.0)];
    [reGetBtn setTitleColor:QNDRGBColor(182, 182, 182) forState:UIControlStateNormal];
    [reGetBtn addTarget:self action:@selector(reGetTheVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    reGetBtn.userInteractionEnabled = NO;
    [self.view addSubview:reGetBtn];
    //开始布局
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.top.mas_equalTo(themeLabel.mas_bottom).with.offset(10);
    }];
    
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.height.equalTo(@40);
        make.top.mas_equalTo(descLabel.mas_bottom).with.offset(30);
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.mas_equalTo(descLabel.mas_bottom).with.offset(100);
        make.right.equalTo(@-30);
        make.height.equalTo(@40);
    }];
    
    [reGetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-30);
        make.top.mas_equalTo(nextBtn.mas_bottom).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(70, 22));
    }];
}

-(void)initTheTimer{
    if (_delayTimer) {
        [_delayTimer invalidate];
        _delayTimer=nil;
    }
    //调整size
    countTime = 59;
    [_secondLabel setText:FORMAT(@"%dS",countTime)];
    reGetBtn.userInteractionEnabled=NO;
    @WHWeakObj(self);
    @WHStrongObj(self);
    self.delayTimer = [NSTimer WH_scheduledTimerWithTimeInterval:1.0 executeBlock:^(NSTimer *timer) {
        [Strongself countNumber:timer];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_delayTimer forMode:NSRunLoopCommonModes];
}

#pragma mark- 重新获取验证码
-(void)reGetTheVerifyCode:(UIButton*)button{
    _codeField.text = @"";
    checkView.hidden = YES;
    [_codeField setRightView:_secondLabel];
    [self getTheVerifyCode];
}

#pragma mark- 返回登录
-(void)backToLoginVC{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 点击下一步
-(void)nextStepTodo:(UIButton*)button{
    if (_apiType == smsLogin) {
        if (KNEEDCPLLOGIN) {
            [self CPl_SmsLogin];
        }else{
            [self SmsLogin];
        }
    }else{
        [self verifyTheSmsCode:_codeField.text];
    }
}

#pragma mark- 心跳调用方法
-(void)countNumber:(NSTimer*)timer{
    self.delayTimer = timer;
    countTime--;
    [_secondLabel setText:FORMAT(@"%dS",countTime)];
    if (countTime == 0) {
        countTime=60;
        [_delayTimer invalidate];
        _delayTimer = nil;
        reGetBtn.userInteractionEnabled = YES;
        [reGetBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    }
}


#pragma mark- 监听输入框改变
-(void)textFieldDidChanged:(UITextField*)textField{
    if ([WHVerify checkTheLength:4 ofString:_codeField.text]) {
        //判断时候验证码是否正确
        nextBtn.backgroundColor = ThemeColor;
        [_codeField setRightView:checkView];
        checkView.hidden = YES;
        [nextBtn setUserInteractionEnabled:YES];
    }else{
        [nextBtn setBackgroundColor:grayBackgroundLightColor];
        [_codeField setRightView:_secondLabel];
        [nextBtn setUserInteractionEnabled:NO];
    }
}


-(void)addTouch{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

-(void)endEdit{
    [self.view endEditing:YES];
}

#pragma mark- 获取验证码
-(void)getTheVerifyCode{
    [self initTheTimer];
    QNDPhoneCodeApi * api = [[QNDPhoneCodeApi alloc]initWithPhoneNum:_mobileNumber andType:_apiType];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSString * str = [request responseJSONObject][@"msg"];
        [self.view makeCenterToast:str];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        NSString * detail = [request responseJSONObject][@"msg"];
        [self.view makeCenterToast:detail];
    }];
}

#pragma mark- 验证验证码是否正确
-(void)verifyTheSmsCode:(NSString*)code{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    QNDPhoneCodeVerifyApi * api = [[QNDPhoneCodeVerifyApi alloc]initWithMobileNum:_mobileNumber andSmsCode:code andSmsType:_apiType];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary * dic = [request responseJSONObject];
        NSInteger status = [dic[@"status"] integerValue];
        if (status==1) {
            //验证成功
            NSDictionary * data = dic[@"data"];
            [[NSUserDefaults standardUserDefaults]setObject:data[@"userId"] forKey:KUserId];
            [[NSUserDefaults standardUserDefaults]setObject:data[@"token"] forKey:KUserToken];
            [[NSUserDefaults standardUserDefaults] setObject:_mobileNumber forKey:KUserPhoneNum];
            //到设置密码页面
            QNDCreatePasswordViewController * passwordVC = [[QNDCreatePasswordViewController alloc]init];
            passwordVC.mobileNumber = _mobileNumber;
            [self.navigationController pushViewController:passwordVC animated:YES];
        }else{
            [self.view makeCenterToast:dic[@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary *dic  = request.responseJSONObject;
        WHLog(@"%@",request.error);
        [self.view makeCenterToast:dic[@"msg"]];
    }];
}

#pragma mark- 验证码登录
-(void)CPl_SmsLogin{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    QNDPhoneCodeVerifyApi * smsloginApi = [[QNDPhoneCodeVerifyApi alloc]initWithMobileNum:_mobileNumber andSmsCode:_codeField.text andSmsType:_apiType];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    CPLLonginApi * CPlApi = [[CPLLonginApi alloc]initWithparamDic:@{@"app_id":CPLAPPID,
                                                                @"app_psw":CPLAPPSecret,                                                                              @"mobile_number":_mobileNumber}];
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    [chain addRequest:smsloginApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSDictionary * dic = [baseRequest responseJSONObject];
        NSInteger status = [dic[@"status"] integerValue];
        if (status==1) {
            //验证成功
            NSDictionary * data = dic[@"data"];
            [[NSUserDefaults standardUserDefaults]setObject:data[@"userId"] forKey:KUserId];
            [[NSUserDefaults standardUserDefaults]setObject:data[@"token"] forKey:KUserToken];
            [[NSUserDefaults standardUserDefaults] setObject:_mobileNumber forKey:KUserPhoneNum];
            [TalkingData trackEvent:@"验证码登录" label:@"验证码登录"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.view makeCenterToast:dic[@"msg"]];
        }
        [TalkingData trackEvent:@"验证码登录" label:@"验证码登录"];
        [chainRequest addRequest:CPlApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            NSDictionary * dic = [baseRequest responseJSONObject][@"data"];
            WHLog(@"dic==%@",dic);
            [user setObject:dic[@"token"] forKey:CPLUserToken];
            [user setBool:NO forKey:KCPLLOGIN];
        }];
    }];
    chain.delegate = self;
    [chain start];
}

-(void)SmsLogin{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    QNDPhoneCodeVerifyApi * api = [[QNDPhoneCodeVerifyApi alloc]initWithMobileNum:_mobileNumber andSmsCode:_codeField.text andSmsType:_apiType];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary * dic = [request responseJSONObject];
        NSInteger status = [dic[@"status"] integerValue];
        if (status==1) {
            //验证成功
            NSDictionary * data = dic[@"data"];
            [[NSUserDefaults standardUserDefaults]setObject:data[@"userId"] forKey:KUserId];
            [[NSUserDefaults standardUserDefaults]setObject:data[@"token"] forKey:KUserToken];
            [[NSUserDefaults standardUserDefaults] setObject:_mobileNumber forKey:KUserPhoneNum];
            [TalkingData trackEvent:@"验证码登录" label:@"验证码登录"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        }else{
            [self.view makeCenterToast:dic[@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary *dic  = request.responseJSONObject;
        WHLog(@"%@",request.error);
        [self.view makeCenterToast:dic[@"msg"]];
    }];
}

#pragma mark -chainrequest的代理方法
-(void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request{
    [[WHLoading ShareInstance]hidenHud];
    if ([request isKindOfClass:[QNDPhoneCodeVerifyApi class]]) {
        NSDictionary *dic  = request.responseJSONObject;
        WHLog(@"%@",request.error);
        [self.view makeCenterToast:dic[@"msg"]];
    }else{
        [self.view makeCenterToast:[request responseJSONObject][@"message"]];
    }
}

-(void)chainRequestFinished:(YTKChainRequest *)chainRequest{
    [[WHLoading ShareInstance]hidenHud];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(UITextField *)codeField{
    if (!_codeField) {
        _codeField = [[UITextField alloc]init];
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.font = QNDFont(18.0);
        _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeField.delegate = self;
        _codeField.tintColor = ThemeColor;
        _codeField.rightViewMode = UITextFieldViewModeAlways;
        [_codeField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];//设置文字间距
        
        _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 17)];
        _secondLabel.textColor = QNDRGBColor(210, 210, 210);
        _secondLabel.font = QNDFont(16.0);
        _secondLabel.text = FORMAT(@"%dS",countTime);
        [_codeField setRightView:_secondLabel];
        
        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [checkView setImage:[UIImage imageNamed:@"login_icon_true"]];
        checkView.hidden = YES;
        //线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ViewWidth-60, 1)];
        line.backgroundColor = grayBackgroundLightColor;
        [_codeField addSubview:line];
    }
    return _codeField;
}


@end
