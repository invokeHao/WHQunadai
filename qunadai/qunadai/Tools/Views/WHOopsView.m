//
//  WHOopsView.m
//  qunadai
//
//  Created by wang on 2017/10/11.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "WHOopsView.h"
@interface WHOopsView ()

@property (copy,nonatomic)doneBlock block;

@end

@implementation WHOopsView
{
    UIImageView * wifiView ;
}
+(instancetype)shareInstance{
    static WHOopsView * oopsView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oopsView = [[WHOopsView alloc]init];
    });
    return oopsView;
}

-(void)showTheOopsViewOneTheView:(UIView *)view WithDoneBlock:(doneBlock)doneblcok{
    WHOopsView * oopsView = [WHOopsView shareInstance];
    oopsView.frame = view.bounds;
    oopsView.block = doneblcok;
    oopsView.backgroundColor = QNDRGBColor(242, 242, 242);
    [oopsView layoutViews];
    [view addSubview:oopsView];
    [view bringSubviewToFront:oopsView];
}

-(void)hidenTheOops{
    [self removeFromSuperview];
}

-(void)layoutViews{
    if (wifiView) {
        return;
    }
    wifiView = [[UIImageView alloc]init];
    [wifiView setImage:[UIImage imageNamed:@"Wi-Fi"]];
    [self addSubview:wifiView];
    
    UILabel * labelA = [[UILabel alloc]init];
    labelA.font = QNDFont(14.0);
    labelA.textColor = black31TitleColor;
    labelA.textAlignment = NSTextAlignmentCenter;
    labelA.text = @"您可能断开了网络连接";
    [self addSubview:labelA];
    
    UILabel * labelB = [[UILabel alloc]init];
    labelB.font = QNDFont(14.0);
    labelB.textColor = QNDRGBColor(177, 182, 193);
    labelB.text = @"请刷新重试";
    labelB.textAlignment = NSTextAlignmentCenter;
    [self addSubview: labelB];
    
    UIButton * refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    refreshBtn.backgroundColor = ThemeColor;
    refreshBtn.layer.cornerRadius = 4;
    refreshBtn.clipsToBounds = YES;
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshBtn.titleLabel setFont:QNDFont(14.0)];
    [refreshBtn addTarget:self action:@selector(pressToRefreshTheRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshBtn];
    
    [wifiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@134);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(104, 72));
    }];
    
    [labelA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wifiView.mas_bottom).with.offset(25);
        make.left.equalTo(@50);
        make.right.equalTo(@-50);
        make.height.equalTo(@15);
    }];
    
    [labelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelA.mas_bottom).with.offset(13);
        make.left.equalTo(@50);
        make.right.equalTo(@-50);
        make.height.equalTo(@15);
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelB.mas_bottom).with.offset(90);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(140, 36));
    }];
}

-(void)pressToRefreshTheRequest:(UIButton*)button{
    _block();
}
@end
