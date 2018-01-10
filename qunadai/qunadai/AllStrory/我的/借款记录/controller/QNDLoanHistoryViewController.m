//
//  QNDLoanHistoryViewController.m
//  qunadai
//
//  Created by wang on 2017/9/26.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDLoanHistoryViewController.h"
#import "ControlAllNavigationViewController.h"
#import "AppDelegate.h"
#import "wangTabBarController.h"

@interface QNDLoanHistoryViewController ()

@property (strong,nonatomic)UIView * NonloanView;//没有贷款页面

@end

@implementation QNDLoanHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.NonloanView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"借款记录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)pressToLoan:(UIButton*)button{
    ControlAllNavigationViewController * allNavVC = [[ControlAllNavigationViewController alloc]initWithRootViewController:[wangTabBarController new]];
    AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController=allNavVC;
}

-(UIView *)NonloanView{
    if (!_NonloanView) {
        _NonloanView = [[UIView alloc]initWithFrame:self.view.bounds];
        _NonloanView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_NonloanView];
        
        UIImageView * iconView = [[UIImageView alloc]init];
        iconView.contentMode = UIViewContentModeCenter;
        [iconView setImage:[UIImage imageNamed:@"empty state"]];
        [_NonloanView addSubview:iconView];
        
        UILabel * label = [[UILabel alloc]init];
        label.font = QNDFont(16.0);
        label.textColor = QNDRGBColor(157, 157, 157);
        label.text = @"您没有借款记录";
        label.textAlignment =NSTextAlignmentCenter;
        [_NonloanView addSubview:label];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"立即借款" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:ThemeColor];
        [button.titleLabel setFont:QNDFont(15)];
        button.layer.cornerRadius = 2;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(pressToLoan:) forControlEvents:UIControlEventTouchUpInside];
        [_NonloanView addSubview:button];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.equalTo(@140);
            make.size.mas_equalTo(CGSizeMake(93, 75));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconView.mas_bottom).with.offset(32);
            make.centerX.mas_equalTo(iconView);
            make.height.equalTo(@17);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).with.offset(20);
            make.centerX.mas_equalTo(iconView);
            make.size.mas_equalTo(CGSizeMake(92, 36));
        }];
    }
    return _NonloanView;
}


@end
