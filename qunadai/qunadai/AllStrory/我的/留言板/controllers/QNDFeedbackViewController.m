//
//  QNDFeedbackViewController.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDFeedbackViewController.h"

#import "QNDFeedbackApi.h"

@interface QNDFeedbackViewController ()

@property (strong,nonatomic)UITextView * MainText;

@property (strong,nonatomic)UILabel * pleaseHolderLabel;

@property (strong,nonatomic)UIButton * postBtn;

@property (assign,nonatomic)QNDFeedbackType type;

@property (copy,nonatomic)NSString * proName;

@end

@implementation QNDFeedbackViewController
{
    UIView * _successView;
    BOOL _isSuccess;//提交成功了
}

-(instancetype)initWithFeedBackType:(QNDFeedbackType)type andProName:(NSString *)name{
    self = [super init];
    if (self) {
        _type = type;
        _proName = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NOTIF_ADD(UITextViewTextDidChangeNotification, textViewDidChanged:);
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"意见反馈";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)layoutViews{
    self.view.backgroundColor = QNDRGBColor(242, 242, 242);
    [self createTapView];
    
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView addSubview:self.MainText];
    [backView addSubview:self.pleaseHolderLabel];
    
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(@-12);
        make.left.equalTo(@12);
        make.height.equalTo(@46);
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@76);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.bottom.mas_equalTo(_postBtn.mas_top).with.offset(-12);
    }];
    
    [_MainText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@16);
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-20);
    }];
    
    [self.pleaseHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@20);
        make.right.equalTo(@-20);
    }];
}

-(void)setUpSuccessView{
    if (!_successView) {
        _successView = [[UIView alloc]init];
        _successView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_successView];
        
        UIImageView * iconView = [[UIImageView alloc]init];
        [iconView setImage:[UIImage imageNamed:@"opinion_icon_success"]];
        [_successView addSubview:iconView];
        
        UILabel * descLabel = [[UILabel alloc]init];
        descLabel.font = QNDFont(15.0);
        descLabel.textColor = black31TitleColor;
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.numberOfLines = 0;
        descLabel.text = @"感谢您的反馈，您反馈的问题我们会尽快解决";
        [_successView addSubview:descLabel];
        //开始布局
        [_successView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@76);
            make.left.equalTo(@12);
            make.right.equalTo(@-12);
            make.bottom.mas_equalTo(_postBtn.mas_top).with.offset(-12);
        }];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@90);
            make.centerX.mas_equalTo(_successView);
            make.size.mas_equalTo(CGSizeMake(66, 66));
        }];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconView.mas_bottom).with.offset(50);
            make.left.equalTo(@25);
            make.right.equalTo(@-25);
        }];
        [self.view bringSubviewToFront:_successView];
    }
}

-(void)pressToPostTheFeedback:(UIButton*)button{
    if (_isSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.MainText.text.length<1) {
        [self.view makeCenterToast:@"输入内容不能为空"];
        return;
    }
    NSString * nameStr = nil;
    if (_type==QNDCPLFeedbackType) {
        nameStr = FORMAT(@"Ios-去哪贷CPL-%@",_proName);
    }else if (_type==CPLProFeedbackType){
        nameStr = FORMAT(@"Ios-CPL-%@",_proName);
    }else{
        nameStr = @"Ios-去哪贷-我的";
    }
    QNDFeedbackApi * api = [[QNDFeedbackApi alloc]initWitContent:self.MainText.text andProName:nameStr];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            [self setUpSuccessView];
            NSString * str = @"回到主页";
            if(_type!=QNDNomalFeedbackType){
                str = @"返回贷款";
            }
            [self.postBtn setTitle:str forState:UIControlStateNormal];
            _isSuccess = YES;
        }else{
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
        WHLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

-(void)createTapView{
    UISwipeGestureRecognizer *recognizer;
    
    self.view.userInteractionEnabled=YES;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [[self view] addGestureRecognizer:recognizer];
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)swipe{
    [self.view endEditing:YES];
}

-(void)textViewDidChanged:(NSNotification*)notification{
    _pleaseHolderLabel.hidden = self.MainText.text.length > 0 ? YES : NO;
}

-(UITextView *)MainText{
    if (!_MainText) {
        _MainText = [[UITextView alloc]init];
        _MainText.tintColor = ThemeColor;
        _MainText.textColor = black31TitleColor;
        _MainText.font = QNDFont(15.0);
    }
    return _MainText;
}

-(UIButton *)postBtn{
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postBtn.titleLabel setFont:QNDFont(18.0)];
        [_postBtn setBackgroundColor:ThemeColor];
        _postBtn.layer.cornerRadius = 23;
        _postBtn.clipsToBounds = YES;
        [_postBtn addTarget:self action:@selector(pressToPostTheFeedback:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_postBtn];
    }
    return _postBtn;
}

-(UILabel *)pleaseHolderLabel{
    if (!_pleaseHolderLabel) {
        _pleaseHolderLabel = [[UILabel alloc]init];
        _pleaseHolderLabel.font = QNDFont(15.0);
        _pleaseHolderLabel.textColor = QNDRGBColor(207, 212, 220);
        _pleaseHolderLabel.numberOfLines = 0;
        _pleaseHolderLabel.text = @"点击此处留言。\n欢迎来到去哪贷意见反馈中心，使用中遇到任何问题都可以在此留言。";
    }
    return _pleaseHolderLabel;
}


@end
