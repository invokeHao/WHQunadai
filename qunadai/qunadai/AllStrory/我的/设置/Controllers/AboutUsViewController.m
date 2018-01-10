//
//  AboutUsViewController.m
//  qunadai
//
//  Created by wang on 17/3/30.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"关于我们";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico"]];
    [iconView setContentMode:UIViewContentModeCenter];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.equalTo(@104);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    UILabel * versonLabel = [[UILabel alloc]init];
    versonLabel.font = QNDFont(12);
    versonLabel.textColor = black74TitleColor;
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versonLabel.text = [NSString stringWithFormat:@"V%@",appVersion];
    versonLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versonLabel];
    [versonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).with.offset(12);
        make.centerX.mas_equalTo(self.view);
        make.height.equalTo(@13);
    }];
    
    UILabel * sloganLabel = [[UILabel alloc]init];
    sloganLabel.font = QNDFont(16.0);
    sloganLabel.textColor = QNDNomalText109Color;
    sloganLabel.textAlignment = NSTextAlignmentCenter;
    sloganLabel.text = @"贷款就上去哪贷    您的贷款专家";
    [self.view addSubview:sloganLabel];
    [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(versonLabel.mas_bottom).with.offset(35);
        make.height.equalTo(@17);
    }];
    
    UILabel * descriptionLabel = [[UILabel alloc]init];
    descriptionLabel.font = QNDFont(13.0);
    descriptionLabel.textColor = QNDNomalText109Color;
    descriptionLabel.numberOfLines = 0;
    NSString * titleStr = @"石家庄恒尼投资管理有限公司(Shijiazhuang HengNi Investment Management Co., Ltd.)";
    if (!KWHSUCCESS) {
        titleStr =  @"上海格禹网络科技有限公司";
    }
    descriptionLabel.text = FORMAT(@"%@ 致力于互联网金融信贷产品的研发与服务。可以通过“去哪贷”APP在线申请借款，解决用户资金困难问题，快速审核，依托互联网大数据作为主要征信源。新进理念和创新技术带来全新的信贷行业。",titleStr);

    [self.view addSubview:descriptionLabel];
    
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@25);
        make.right.equalTo(@-25);
        make.top.mas_equalTo(sloganLabel.mas_bottom).with.offset(12);
    }];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = lightGrayBackColor;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@0.5);
        make.top.mas_equalTo(descriptionLabel.mas_bottom).with.offset(50);
    }];
    
    UILabel * WXlabel = [[UILabel alloc]init];
    WXlabel.font = QNDFont(15.0);
    WXlabel.textColor = QNDNomalText109Color;
    WXlabel.textAlignment = NSTextAlignmentCenter;
    WXlabel.text = @"微信公众号: 去哪贷服务";
    [self.view addSubview:WXlabel];
    
    [WXlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).with.offset(10);
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(50);
        make.height.equalTo(@16);
    }];
    
    UIImageView * WXicon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixin"]];
    WXicon.contentMode = UIViewContentModeCenter;
    [self.view addSubview:WXicon];
    
    [WXicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WXlabel);
        make.right.mas_equalTo(WXlabel.mas_left).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];

    UILabel * QQlabel = [[UILabel alloc]init];
    QQlabel.font = QNDFont(15.0);
    QQlabel.textAlignment = NSTextAlignmentCenter;
    QQlabel.textColor = QNDNomalText109Color;
    QQlabel.text = @"商务QQ: 2926366832";
    [self.view addSubview:QQlabel];
    [QQlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WXlabel.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.view).with.offset(10);
        make.height.equalTo(@16);
    }];
    
    UIImageView * QQicon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qq"]];
    QQicon.contentMode = UIViewContentModeCenter;
    [self.view addSubview:QQicon];
    [QQicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(QQlabel);
        make.right.mas_equalTo(QQlabel.mas_left).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];
    
    UILabel * bottomLabel = [[UILabel alloc]init];
    bottomLabel.font = QNDFont(12.0);
    bottomLabel.textColor = QNDNomalText109Color;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"copyright © 2015去哪贷 All Rights Reserved";
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-15);
        make.centerX.mas_equalTo(self.view);
        make.height.equalTo(@13);
    }];
    
}

@end
