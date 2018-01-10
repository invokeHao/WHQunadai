//
//  QNDLoanSuccessViewController.m
//  qunadai
//
//  Created by wang on 2017/9/25.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDLoanSuccessViewController.h"

@interface QNDLoanSuccessViewController ()

@end

@implementation QNDLoanSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"借款成功";
}

-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * successView = [[UIImageView alloc]init];
    [successView setImage:[UIImage imageNamed:@"icon_right"]];
    [self.view addSubview:successView];
    
    UILabel * label1 = [[UILabel alloc]init];
    label1.font = QNDFont(16.0);
    label1.textColor = QNDRGBColor(157, 157, 157);
    label1.text = @"借款请求发送成功";
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]init];
    label2.text = @"审核通过将会联系您";
    label2.font = QNDFont(16.0);
    label2.textColor = QNDRGBColor(157, 157, 157);
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomBtn setBackgroundColor:ThemeColor];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn.titleLabel setFont:QNDFont(18)];
    bottomBtn.layer.cornerRadius = 2;
    bottomBtn.clipsToBounds = YES;
    [bottomBtn addTarget:self action:@selector(pressTheBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@144);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(73, 73));
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successView.mas_bottom).with.offset(40);
        make.height.equalTo(@17);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.view);
        make.height.equalTo(@17);
    }];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.height.equalTo(@46);
        make.bottom.equalTo(@-49);
    }];
}

-(void)pressTheBottomBtn:(UIButton*)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
