//
//  WHUpdateView.m
//  qunadai
//
//  Created by wang on 2017/10/10.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "WHUpdateView.h"
#import "NSString+extention.h"

@interface WHUpdateView()

@property (copy,nonatomic) NSString * updateContent;

@property (assign,nonatomic) UpdateType type;

@end

@implementation WHUpdateView
{
    UIView * backView;//后面的黑色背景
    UIView * contentView;//内容区域
    NSString * _updateContent;//更新内容
    UpdateType _type;//更新类型
}
+(void)showTheUpdateViewWithContent:(NSString *)content andType:(UpdateType)type{
    WHUpdateView * view = [[WHUpdateView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    view.updateContent = content;
    view.type = type;
    [view layoutViews];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
}

-(void)layoutViews{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.32];
    [self addSubview:backView];
    //计算更新内容的高度
    contentView = [[UIView alloc]init];
    contentView.center = self.center;
    contentView.bounds = CGRectMake(0, 0, 212, 260);
    contentView.layer.cornerRadius = 4;
    contentView.clipsToBounds = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UIImageView * topview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentView.width, 140)];
    [topview setImage:[UIImage imageNamed:@"update_bg"]];
    [contentView addSubview:topview];
    
    //中间有一条线
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:lineView];
    
    UILabel * contentLabel = [[UILabel alloc]init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = QNDFont(13.0);
    contentLabel.textColor  = black31TitleColor;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = self.updateContent;
    [contentView addSubview:contentLabel];
    
    NSString * cancelStr = @"稍后更新";
    NSString * updateStr = @"马上更新";
    if (self.type==ForceUpdateType) {
        cancelStr = @"关闭";
    }
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:cancelStr forState:UIControlStateNormal];
    [leftBtn setTitleColor:black31TitleColor forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:QNDFont(13)];
    [leftBtn addTarget:self action:@selector(cancelTheUpdate:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:leftBtn];
    
    UIView * btnTopLine = [[UIView alloc]init];
    btnTopLine.backgroundColor = lightGrayBackColor;
    [contentView addSubview:btnTopLine];
    
    UIView * BtnLine = [[UIView alloc]init];
    BtnLine.backgroundColor = lightGrayBackColor;
    [contentView addSubview:BtnLine];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:QNDRGBColor(210, 183, 144) forState:UIControlStateNormal];
    [rightBtn setTitle:updateStr forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:QNDFont(13.0)];
    [rightBtn addTarget:self action:@selector(updateTheApp:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:rightBtn];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@139.5);
        make.height.equalTo(@0.5);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(14);
    }];
    [btnTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@-44.5);
        make.height.equalTo(@0.5);
    }];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(contentView.width/2, 44));
    }];
    
    [BtnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftBtn.mas_right).with.offset(0);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(@-5);
        make.height.equalTo(@34);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(contentView.width/2, 44));
    }];
}

-(void)cancelTheUpdate:(UIButton*)btn{
    if (self.type==ForceUpdateType) {
        //关闭
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        
        [UIView animateWithDuration:0.3f animations:^{
            window.transform = CGAffineTransformMakeScale(1.0, 1/[UIScreen mainScreen].bounds.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                window.transform = CGAffineTransformMakeScale(1/[UIScreen mainScreen].bounds.size.width, 1/[UIScreen mainScreen].bounds.size.height);
            } completion:^(BOOL finished) {
                exit(1);
            }];
        }];
    }else{
        [self removeFromSuperview];
    }
}

-(void)updateTheApp:(UIButton*)btn{
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", APPStoreId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
@end
