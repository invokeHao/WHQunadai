//
//  QNDCreatePasswordViewController.m
//  qunadai
//
//  Created by wang on 2017/9/6.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDCreatePasswordViewController.h"

#import "smsRestPasswordApi.h"
#import "CPLLonginApi.h"


#import "NSString+extention.h"
#import "WHVerify.h"


@interface QNDCreatePasswordViewController ()<UITextFieldDelegate,YTKChainRequestDelegate>

@property (strong,nonatomic)UITextField * passwordField;//验证码输入框


@end

@implementation QNDCreatePasswordViewController
{
    UIButton * _secritBtn;
    UIButton * nextBtn;//下一步
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTouch];
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
    [themeLabel setText:@"创建密码"];
    [self.view addSubview:themeLabel];
    
    UILabel * descLabel = [[UILabel alloc]init];
    descLabel.font = QNDFont(14.0);
    descLabel.text = @"请设置由字母和数字组成的密码，且长度为六到十六个字符。";
    descLabel.textColor = QNDRGBColor(210, 210, 210);
    descLabel.numberOfLines = 0;
    [self.view addSubview:descLabel];
    
    [self.view addSubview:self.passwordField];
    
    //下一步按钮
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(0, 0, ViewWidth-60, 40)];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:grayBackgroundLightColor];
    [nextBtn.titleLabel setFont:QNDFont(18.0)];
    [nextBtn addTarget:self action:@selector(pressTheFinishBtn:) forControlEvents:
     UIControlEventTouchUpInside];
    [nextBtn setUserInteractionEnabled:NO];
    nextBtn.layer.cornerRadius = 2;
    nextBtn.clipsToBounds=YES;
    [self.view addSubview:nextBtn];
    
    //开始布局
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.top.mas_equalTo(themeLabel.mas_bottom).with.offset(10);
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
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
}

#pragma mark- 监听输入框改变
-(void)textFieldDidChanged:(UITextField*)textField{
    if ([WHVerify checkPass:_passwordField.text]) {
        nextBtn.backgroundColor = ThemeColor;
        [nextBtn setUserInteractionEnabled:YES];
    }else{
        [nextBtn setBackgroundColor:grayBackgroundLightColor];
        [nextBtn setUserInteractionEnabled:NO];
    }
}

#pragma mark- 返回登录
-(void)backToLoginVC{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-更改明暗文
-(void)changeSecture:(UIButton*)button{
    _passwordField.secureTextEntry = button.selected;
    button.selected = !button.selected;
}
-(void)addTouch{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

-(void)endEdit{
    [self.view endEditing:YES];
}

-(void)pressTheFinishBtn:(UIButton*)button{
    if (KNEEDCPLLOGIN) {
        [self Cpl_setupTheQunadai];
    }else{
        [self setupTheQunadai];
    }
}

#pragma mark- 注册

-(void)Cpl_setupTheQunadai{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    YTKRequest * qndApi = [[smsRestPasswordApi alloc]initWithPhoneNum:_mobileNumber andPassword:[NSString sha1:_passwordField.text]];

    CPLLonginApi * CPlApi = [[CPLLonginApi alloc]initWithparamDic:@{@"app_id":CPLAPPID,
                                                                @"app_psw":CPLAPPSecret,                                                                              @"mobile_number":_mobileNumber}];
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    [chain addRequest:qndApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSDictionary * dic = [baseRequest responseJSONObject];
        [self.view makeToast:dic[@"msg"]];
        [TalkingData trackEvent:@"密码设置页" label:@"密码设置页"];
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

-(void)setupTheQunadai{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    YTKRequest * qndApi = [[smsRestPasswordApi alloc]initWithPhoneNum:_mobileNumber andPassword:[NSString sha1:_passwordField.text]];

    [qndApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary * dic = [request responseJSONObject];
        [self.view makeToast:dic[@"msg"]];
        [TalkingData trackEvent:@"密码设置页" label:@"密码设置页"];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSString * detail = [request responseJSONObject][@"detail"];
        [self.view makeCenterToast:detail];
    }];
}

-(void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request{
    [[WHLoading ShareInstance]hidenHud];
    if ([request isKindOfClass:[CPLLonginApi class]]) {
        [self.view makeCenterToast:[request responseJSONObject][@"message"]];
    }else{
        NSString * detail = [request responseJSONObject][@"detail"];
        [self.view makeCenterToast:detail];
    }
}

-(void)chainRequestFinished:(YTKChainRequest *)chainRequest{
    [[WHLoading ShareInstance]hidenHud];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(UITextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc]init];
        _passwordField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordField.font = QNDFont(18.0);
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.delegate = self;
        _passwordField.secureTextEntry = YES;
        _passwordField.tintColor = ThemeColor;
        _passwordField.rightViewMode = UITextFieldViewModeAlways;
        [_passwordField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];//设置文字间距
        
        _secritBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_secritBtn setImage:[UIImage imageNamed:@"login_icon_close eye"] forState:UIControlStateNormal];
        [_secritBtn setImage:[UIImage imageNamed:@"login_icon_eye"] forState:UIControlStateSelected];
        [_secritBtn addTarget:self action:@selector(changeSecture:) forControlEvents:UIControlEventTouchUpInside];
        [_passwordField setRightView:_secritBtn];
        //线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ViewWidth-60, 1)];
        line.backgroundColor = grayBackgroundLightColor;
        [_passwordField addSubview:line];
    }
    return _passwordField;
}



@end
