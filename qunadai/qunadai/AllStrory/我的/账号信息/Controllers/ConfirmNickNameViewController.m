//
//  ConfirmNickNameViewController.m
//  qunadai
//
//  Created by wang on 17/3/30.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "ConfirmNickNameViewController.h"

#import "ModifyInfoApi.h"

@interface ConfirmNickNameViewController ()
{
    UIButton * saveBtn;//保存按钮
}

@property (strong,nonatomic)UITextField * nicknameText;
@end

@implementation ConfirmNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTouch];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"修改昵称";
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:QNDFont(16.0)];
    [saveBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [saveBtn addTarget:self action:@selector(pressToSave) forControlEvents:UIControlEventTouchUpInside];
    
    [[WHTool shareInstance] setupNavigationRightButton:self RightButton:saveBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    self.view.backgroundColor = grayBackgroundLightColor;
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(15, 10+64, ViewWidth-30, 60)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.clipsToBounds = YES;
    [self.view addSubview:backView];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(14.0);
    attrs[NSForegroundColorAttributeName] = defaultPlaceHolderColor;
    
    _nicknameText = [[UITextField alloc]init];
    _nicknameText.font = QNDFont(14.0);
    _nicknameText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"待用名" attributes:attrs];
    _nicknameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nicknameText.tintColor= ThemeColor;
    if (_nickName) {
        _nicknameText.text = _nickName;
    }
    [backView addSubview:_nicknameText];
    
    [_nicknameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.centerY.mas_equalTo(backView);
        make.height.equalTo(@35);
    }];
}

#pragma mark- 保存昵称

-(void)pressToSave{
    int bytes = [self stringConvertToInt:_nicknameText.text];
    //需要规定昵称长度
    if (bytes>3&&bytes<17) {
        [self.view endEditing:YES];
        //上传昵称
        [self modifyTheNickWithNick:_nicknameText.text];

    }else if(bytes<4){
        [self.view makeToast:@"您的昵称过短" duration:1.7 position:[NSValue valueWithCGPoint:CGPointMake(ViewWidth/2, ViewHeight/2)]];
    }else if (bytes>16){
        [self.view makeToast:@"您的昵称过长" duration:1.7 position:[NSValue valueWithCGPoint:CGPointMake(ViewWidth/2, ViewHeight/2)]];
    }
}

-(void)modifyTheNickWithNick:(NSString*)nick{
    ModifyInfoApi * api = [[ModifyInfoApi alloc]initWithNickName:nick];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    [self.navigationController popViewControllerAnimated:YES];
    [self.parentViewController.view makeToast:@"保存成功" duration:1.7 position:[NSValue valueWithCGPoint:CGPointMake(ViewWidth/2, ViewHeight/2)]];
        WHLog(@"success==%@",[request responseJSONObject]);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"falie==%@",[request responseJSONObject]);
    }];
}

-(void)addTouch{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEndEdit:)];
    [self.view addGestureRecognizer:tap];
}

-(void)tapEndEdit:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

#pragma mark-字符串改变为字节
- (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1);
}


@end
