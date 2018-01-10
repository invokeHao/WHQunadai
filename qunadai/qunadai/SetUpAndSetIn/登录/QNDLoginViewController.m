//
//  LoginViewController.m
//  qunadai
//
//  Created by wang on 17/3/22.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDLoginViewController.h"
#import "QNDVerifyCodeViewController.h"
#import "WHJSWebViewController.h"

#import "ControlAllNavigationViewController.h"
#import "wangTabBarController.h"
#import "AppDelegate.h"

#import "QNDpasswordLoginApi.h"
#import "QNDIsMobileNumSetupApi.h"
#import "CPLLonginApi.h"

#import "NSString+extention.h"
#import "WHVerify.h"
#import "NSTimer+WHTool.h"

@interface QNDLoginViewController ()<UITextFieldDelegate,YTKChainRequestDelegate>
{
    UILabel * themeLabel;//登录或注册
    UIButton * forgetBtn ;//忘记密码
    UIButton * verifyCodeBtn;//验证码按钮
    UIButton * sectureButton;//显示明暗文按钮
    UIButton * iconBtn;//用户协议按钮
    UIView * functionView;//功能view
    UIImageView * bingoIcon;//判断手机号icon
    NSMutableDictionary *attrs;
    BOOL haveSetup ;
    
}
@property (strong,nonatomic) UITextField * PhoneText; //账号或者手机号
@property (strong,nonatomic) UITextField * codeText; //验证码或者密码
@property (strong,nonatomic) UIButton * nextBtn;//下一步或者登录按钮

@end

@implementation QNDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTouch];
    [self layoutView];
    NOTIF_ADD(UITextFieldTextDidChangeNotification, textFieldDidChanged:);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [TalkingData trackPageBegin:@"登录/注册页"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"登录/注册页"];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark- 页面布局
-(void)layoutView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"login_icon_del"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeLeft];
    [backBtn setFrame:CGRectMake(10, 30, 40, 30)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
    [backBtn addTarget:self action:@selector(backToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    //抬头的标题
    themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 74, 140, 31)];
    themeLabel.font = QNDFont(30);
    themeLabel.textColor = blackTitleColor;
    themeLabel.text = @"注册/登录";
    [self.view addSubview:themeLabel];
    
    attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(18.0);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    //创建两个输入框
    [self.view addSubview:self.PhoneText];
    bingoIcon.hidden = YES;
    [self.view addSubview:self.codeText];
    [self setupFuctionView];
    
    UIView * policyView = [[UIView alloc]init];
    policyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:policyView];
    
    iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setImage:[UIImage imageNamed:@"login_icon_check"] forState:UIControlStateSelected];
    [iconBtn setImage:[UIImage imageNamed:@"login_icon_no_check"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(checkThePolicy:) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.selected = YES;
    [policyView addSubview:iconBtn];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"注册/登录即代表我同意";
    label.textColor = QNDRGBColor(210, 210, 210);
    label.font = QNDFont(12.0);
    [policyView addSubview:label];
    
    UIButton * policyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [policyBtn setTitle:@"《去哪贷服务协议》" forState:UIControlStateNormal];
    [policyBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [policyBtn.titleLabel setFont:QNDFont(12.0)];
    [policyBtn addTarget:self action:@selector(readTheUserPolicy:) forControlEvents:UIControlEventTouchUpInside];
    [policyView addSubview:policyBtn];
    
    [policyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.equalTo(@-44);
        make.size.mas_equalTo(CGSizeMake(260, 22));
    }];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.mas_equalTo(policyView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconBtn.mas_right).with.offset(2);
        make.centerY.mas_equalTo(policyView);
        make.height.equalTo(@13);
    }];
    [policyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).with.offset(0);
        make.centerY.mas_equalTo(policyView);
        make.size.mas_equalTo(CGSizeMake(110, 22));
    }];
}

-(void)setupFuctionView{
    functionView = [[UIView alloc]initWithFrame:CGRectMake(30, 220, ViewWidth-60, 72)];
    functionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:functionView];
    
    //下一步按钮
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setFrame:CGRectMake(0, 0, ViewWidth-60, 40)];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:grayBackgroundLightColor];
    [_nextBtn.titleLabel setFont:QNDFont(18.0)];
    [_nextBtn addTarget:self action:@selector(loginToQunadai) forControlEvents:
     UIControlEventTouchUpInside];
    _nextBtn.layer.cornerRadius = 2;
    _nextBtn.clipsToBounds=YES;
    [_nextBtn setUserInteractionEnabled:NO];
    [functionView addSubview:_nextBtn];
    
    forgetBtn = [self createButtonWithTitle:@"验证码登录"];
    [forgetBtn setFrame:CGRectMake(-2, 50, 65, 22)];
    [forgetBtn addTarget:self action:@selector(smsCodeLogin:) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:forgetBtn];
    
    verifyCodeBtn = [self createButtonWithTitle:@"忘记密码"];
    [verifyCodeBtn setFrame:CGRectMake(ViewWidth-60-50, 50, 53, 22)];
    [verifyCodeBtn addTarget:self action:@selector(resetThePassword:) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:verifyCodeBtn];
}


-(UIButton*)createButtonWithTitle:(NSString*)title {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:QNDAssistText153Color forState:UIControlStateNormal];
    [button.titleLabel setFont:QNDFont(12.0)];
    return button;
}

-(UIImageView * )createImageViewWithFrame:(CGRect)frame ImageString:(NSString*)imageStr{
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:frame];
    imageV.image = [UIImage imageNamed:imageStr];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    return imageV;
}
#pragma mark-更改明暗文
-(void)changeSecture:(UIButton*)button{
    _codeText.secureTextEntry = button.selected;
    button.selected = !button.selected;
}

#pragma mark- 验证码登录
-(void)smsCodeLogin:(UIButton*)button{
    if (haveSetup&&[WHVerify checkTelNumber:_PhoneText.text]&&_PhoneText.text.length==11) {
        QNDVerifyCodeViewController * verifyVC = [[QNDVerifyCodeViewController alloc]init];
        verifyVC.mobileNumber = _PhoneText.text;
        verifyVC.apiType = smsLogin;
        [self.navigationController pushViewController:verifyVC animated:YES];
    }else{
        if (![WHVerify checkTelNumber:_PhoneText.text]) {
            [self.view makeCenterToast:@"请输入正确的手机号"];
        }
       else if (!haveSetup) {
           [self.view makeCenterToast:@"此手机号暂未注册"];
        }
    }
}

#pragma mark-忘记密码
-(void)resetThePassword:(UIButton*)button{
    if (haveSetup&&[WHVerify checkTelNumber:_PhoneText.text]&&_PhoneText.text.length==11) {
        QNDVerifyCodeViewController * verifyVC = [[QNDVerifyCodeViewController alloc]init];
        verifyVC.mobileNumber = _PhoneText.text;
        verifyVC.apiType = smsReset;
        [self.navigationController pushViewController:verifyVC animated:YES];
    }else{
        if (![WHVerify checkTelNumber:_PhoneText.text]) {
            [self.view makeCenterToast:@"请输入正确的手机号"];
        }
        else if (!haveSetup) {
            [self.view makeCenterToast:@"此手机号暂未注册"];
        }
    }
}

#pragma mark-判断登录还是注册
-(void)loginToQunadai{
    //判断是下一步还是登录
    [self.view endEditing:YES];
    if (haveSetup) {
        //密码登录
        if (KNEEDCPLLOGIN) {
            [self CPL_passWordLogin];
        }else{
            [self passWordLogin];
        }
    }else{
     // 去注册
        QNDVerifyCodeViewController * verifyVC = [[QNDVerifyCodeViewController alloc]init];
        verifyVC.mobileNumber = self.PhoneText.text;
        verifyVC.apiType = smsSetup;
        [self.navigationController pushViewController:verifyVC animated:YES];
    }
}

-(void)gotoMainStrory{
    NOTIF_POST(KNOTIFICATION_LOGOUT, @YES);
    [TalkingData trackEvent:@"完成密码登录" label:@"完成密码登录"];
}

#pragma mark-验证码相关

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _PhoneText) {
        if (![WHVerify checkTelNumber:_PhoneText.text]&&_PhoneText.text.length>0) {
            [self.view makeCenterToast:@"请输入正确的手机号"];
        }
    }
}

-(void)textFieldDidChanged:(UITextField*)textField{
    if ([_PhoneText isEditing]) {
        if ([WHVerify checkTelNumber:_PhoneText.text]||_PhoneText.text.length==11) {
            bingoIcon.hidden = NO;
            [bingoIcon setImage:[UIImage imageNamed:@"login_icon_true"]];
            [_nextBtn setUserInteractionEnabled:YES];
            [self IsANewAcount:_PhoneText.text];
        }
        if (![WHVerify checkTelNumber:_PhoneText.text]&&_PhoneText.text.length>10) {
            //显示叉号
            bingoIcon.hidden = NO;
            [bingoIcon setImage:[UIImage imageNamed:@"login_icon_false"]];
            [_nextBtn setUserInteractionEnabled:NO];
        }
        if (_PhoneText.text.length<11) {
            bingoIcon.hidden = YES;
            [_nextBtn setUserInteractionEnabled:NO];
        }
    }
    if ([WHVerify checkPassword:_codeText.text] &&[WHVerify checkTelNumber:_PhoneText.text]) {
        [_nextBtn setBackgroundColor:ThemeColor];
        [_nextBtn setUserInteractionEnabled:YES];
    }
    
    if(![WHVerify checkPassword:_codeText.text] || ![WHVerify checkTelNumber:_PhoneText.text]){
        [_nextBtn setBackgroundColor:grayBackgroundLightColor];
    }
}

-(void)addTouch{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

-(void)endEdit{
    [self.view endEditing:YES];
}

#pragma mark-查看用户协议
-(void)checkThePolicy:(UIButton*)button{
    button.selected = !button.selected;
}

-(void)readTheUserPolicy:(UIButton*)button{
    //查看用户协议
    WHJSWebViewController * webVC = [[WHJSWebViewController alloc]init];
    webVC.Url = FORMAT(@"%@#/policy",WYBaseUrl);;
    webVC.titleName = @"用户协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark- 返回登录
-(void)backToLoginVC{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark-数据处理相关
//验证手机是否注册过
-(void)IsANewAcount:(NSString*)PhoneNum{
    @WHWeakObj(self);
    @WHStrongObj(self);
    [[WHLoading ShareInstance]showImageHUD:self.view];
    QNDIsMobileNumSetupApi * api = [[QNDIsMobileNumSetupApi alloc]initWithMobileNumber:PhoneNum];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSString * resultStr = [request responseJSONObject][@"data"][@"result"];
        haveSetup = [resultStr boolValue];
        if (haveSetup) {
            //有账号的话，显示密码框
            POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            spring.springBounciness = 20;//设置弹性系数，数值越大，震动幅度越大
            spring.springSpeed = 10;//设置速度，速度越快，动画效果越快结束
            spring.toValue = @(320);
            [functionView.layer pop_addAnimation:spring forKey:nil];
            [UIView animateWithDuration:1.0 animations:^{
                Strongself.codeText.alpha = 1.0;
            }];
            [Strongself.nextBtn setTitle:@"登录" forState:UIControlStateNormal];
            [Strongself.nextBtn setBackgroundColor:grayBackgroundLightColor];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                Strongself.codeText.alpha = 0.0;
            }];

            POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            spring.springBounciness = 20;//设置弹性系数，数值越大，震动幅度越大
            spring.springSpeed = 10;//设置速度，速度越快，动画效果越快结束
            spring.toValue = @(250);
            [functionView.layer pop_addAnimation:spring forKey:nil];
            [Strongself.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [Strongself.nextBtn setBackgroundColor:ThemeColor];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [[WHLoading ShareInstance]hidenHud];
        if (![WHVerify checkTelNumber:_PhoneText.text]||_PhoneText.text.length>11) {
            [self.view makeCenterToast:@"请输入正确的手机号"];
        }
    }];
}

-(void)CPL_passWordLogin{
    //需要做联合登录CPL
    [[WHLoading ShareInstance]showImageHUD:self.view];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    QNDpasswordLoginApi  * qndLoginApi = [[QNDpasswordLoginApi alloc]initWithPhoneNum:_PhoneText.text andPassWord:[NSString sha1:_codeText.text]];
    CPLLonginApi * CPlApi = [[CPLLonginApi alloc]initWithparamDic:@{@"app_id":CPLAPPID,
                                 @"app_psw":CPLAPPSecret,                                                                              @"mobile_number":_PhoneText.text}];
    
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    [chain addRequest:qndLoginApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSDictionary * dataDic = [baseRequest responseJSONObject][@"data"];
        NSInteger status = [dataDic[@"status"] integerValue];;
        //存储密码，UID和token
        if (status==1) {
            [user setObject:dataDic[@"userId"] forKey:KUserId];
            [user setObject:dataDic[@"token"] forKey:KUserToken];
            [user setObject:dataDic[@"mobile"] forKey:KUserPhoneNum];
            WHLog(@"token====%@",[user objectForKey:KUserToken]);
            [TalkingData trackEvent:@"密码登录" label:@"密码登录"];
        }else{
            [self.view makeCenterToast:dataDic[@"desc"]];
        }
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

-(void)passWordLogin{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    QNDpasswordLoginApi  * qndLoginApi = [[QNDpasswordLoginApi alloc]initWithPhoneNum:_PhoneText.text andPassWord:[NSString sha1:_codeText.text]];

    [qndLoginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary * dataDic = [request responseJSONObject][@"data"];
        NSInteger status = [dataDic[@"status"] integerValue];;
        //存储密码，UID和token
        if (status==1) {
            [user setObject:dataDic[@"userId"] forKey:KUserId];
            [user setObject:dataDic[@"token"] forKey:KUserToken];
            [user setObject:dataDic[@"mobile"] forKey:KUserPhoneNum];
            WHLog(@"token====%@",[user objectForKey:KUserToken]);
            [TalkingData trackEvent:@"密码登录" label:@"密码登录"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.view makeCenterToast:dataDic[@"desc"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary *dic  = request.responseJSONObject;
        WHLog(@"%@",request.error);
        [self.view makeCenterToast:dic[@"msg"]];
    }];
}

-(void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request{
    [[WHLoading ShareInstance]hidenHud];
    if ([request isKindOfClass:[QNDpasswordLoginApi class]]) {
        NSDictionary *dic  = request.responseJSONObject;
        WHLog(@"%@",request.error);
        [self.view makeCenterToast:dic[@"msg"]];
    }else{
        [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
    }
}

-(void)chainRequestFinished:(YTKChainRequest *)chainRequest{
    [[WHLoading ShareInstance]hidenHud];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(UITextField *)PhoneText{
    if (!_PhoneText) {
        _PhoneText = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(themeLabel.frame)+52, ViewWidth-60, 40)];
        _PhoneText.keyboardType = UIKeyboardTypeNumberPad;
        _PhoneText.font = QNDFont(18.0);
        _PhoneText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:attrs];
        _PhoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _PhoneText.delegate = self;
        _PhoneText.tintColor = ThemeColor;
        _PhoneText.leftViewMode = UITextFieldViewModeAlways;
        _PhoneText.rightViewMode = UITextFieldViewModeAlways;

        //线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ViewWidth-60, 1)];
        line.backgroundColor = grayBackgroundLightColor;
        [_PhoneText addSubview:line];
        
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
        leftView.backgroundColor = [UIColor clearColor];
        [_PhoneText setLeftView:leftView];
    
        UIImageView * phoneIcon = [self createImageViewWithFrame:CGRectMake(0, 0,18, 18) ImageString:@"login_icon_phone"];
        [leftView addSubview:phoneIcon];
        
        UILabel * foreLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneIcon.frame)+15, 1, 40, 16)];
        [foreLabel setFont:QNDFont(18.0)];
        [foreLabel setText:@"+86"];
        [foreLabel setTextColor:defaultPlaceHolderColor];
        [leftView addSubview:foreLabel];
        
        bingoIcon = [self createImageViewWithFrame:CGRectMake(0, 0, 20, 20) ImageString:@"login_icon_true"];
        [_PhoneText setRightView:bingoIcon];
        
    }
    return _PhoneText;
}

-(UITextField *)codeText{
    if (!_codeText) {
        _codeText = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_PhoneText.frame)+20, ViewWidth-60, 40)];
        _codeText.secureTextEntry =YES;
        _codeText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:attrs];
        _codeText.keyboardType = UIKeyboardTypeASCIICapable;
        _codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeText.autocorrectionType = UITextAutocapitalizationTypeNone;
        _codeText.font = QNDFont(18.0);
        _codeText.delegate = self;
        _codeText.alpha = 0;//开始隐藏
        _codeText.tintColor = ThemeColor;
        _codeText.leftViewMode = UITextFieldViewModeAlways;
        _codeText.rightViewMode = UITextFieldViewModeAlways;
//        [_codeText setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];//设置文字间距
        //线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ViewWidth-60, 1)];
        line.backgroundColor = grayBackgroundLightColor;
        [_codeText addSubview:line];
        
        UIImageView * codeIcon = [self createImageViewWithFrame:CGRectMake(0, 0,38, 18) ImageString:@"login_icon_lock"];
        [codeIcon setContentMode:UIViewContentModeLeft];
        _codeText.leftView = codeIcon;
        
        //密码明暗文button
        sectureButton = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 20, 20)];
        [sectureButton addTarget:self action:@selector(changeSecture:) forControlEvents:UIControlEventTouchUpInside];
        [sectureButton setBackgroundImage:[UIImage imageNamed:@"login_icon_close eye"] forState:UIControlStateNormal];
        [sectureButton setBackgroundImage:[UIImage imageNamed:@"login_icon_eye"] forState:UIControlStateSelected];
        [_codeText setRightView:sectureButton];
        
    }
    return _codeText;
}


@end
