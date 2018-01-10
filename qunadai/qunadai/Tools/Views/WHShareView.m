//
//  WHShareView.m
//  qunadai
//
//  Created by wang on 2017/9/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "WHShareView.h"
#import "WXApi.h"

#define KShareViewHeight 144

@interface WHShareView()

@property (copy,nonatomic)NSString * title;

@property (copy,nonatomic)NSString * message;

@property (copy,nonatomic)NSString * thumbImage;

@end

@implementation WHShareView
{
    UIView * contentView;
}

+(void)initWithTitle:(NSString *)title Message:(NSString *)message andThumbImage:(NSString *)imageStr{
    WHShareView * shareView = [[WHShareView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    shareView.title = title;
    shareView.message = message;
    shareView.thumbImage = imageStr;
    [shareView initViews];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:shareView];
    [shareView show];
}

-(void)show{
    CGRect shareRect = contentView.frame;
    shareRect.origin.y = ViewHeight - contentView.height;
    [UIView animateWithDuration:0.3 animations:^{
        contentView.frame = shareRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
}

-(void)dismiss{
    CGRect shareRect = contentView.frame;
    shareRect.origin.y = ViewHeight;
    [UIView animateWithDuration:0.3 animations:^{
        contentView.frame = shareRect;
        self.backgroundColor= [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)initViews{
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, KShareViewHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = QNDFont(14.0);
    titleLabel.textColor = black31TitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"分享给好友后，即可获得现金红包";
    [titleLabel setFrame:CGRectMake(12, 12, ViewWidth-24, 15)];
    [contentView addSubview:titleLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+12, ViewWidth, 1)];
    lineView.backgroundColor = lightGrayBackColor;
    [contentView addSubview:lineView];
    
    NSArray*imageArray=@[@"share_icon_wechat",@"share_icon_circle",@"share_icon_link"];
    NSArray*titleArray=@[@"微信好友",@"朋友圈",@"复制链接"];
    
    CGFloat margin=(ViewWidth-3*40)/4;
    
    NSInteger k=0;
    for (int i=0; i<1; i++) {
        for (int j=0; j<titleArray.count; j++) {
            UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(margin+(40+margin)*j, lineView.y+18+(70+40)*i, 40, 40)];
            button.tag=600+k;
            [button setImage:[UIImage imageNamed:imageArray[k]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pressTheShareButton:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:button];
            
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x-10, button.frame.origin.y+button.height+7, 60, 14)];
            label.text=titleArray[k];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=QNDFont(12.0);
            label.textColor = QNDNomalText109Color;
            [contentView addSubview:label];
            k++;
            if (k>3) {
                break;
            }
        }
    }
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight- KShareViewHeight)];
    backView.backgroundColor = [UIColor clearColor];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelShare)];
    [backView addGestureRecognizer:tap];
}


-(void)cancelShare{
    [self dismiss];
}


-(void)pressTheShareButton:(UIButton*)button
{
    switch (button.tag) {
        case 600:
            [self shareWechatFriend:button];
            break;
        case 601:
            [self shareWechatGroup:button];
            break;
        case 602:
            [self copyTheLink:button];
        default:
            break;
    }
}

#pragma mark-分享到微信好友
-(void)shareWechatFriend:(UIButton*)button{
    if (![WXApi isWXAppInstalled]) {
        [[WHTool shareInstance]showALterViewWithOneButton:@"您不能使用分享功能" andMessage:@"您没有安装微信"];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _title;
    message.description = _message;
    [message setThumbImage:[UIImage imageNamed:_thumbImage]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = FORMAT(@"https://m.qunadai.com/land/loginDownload/index.html?channelCode=ShareTest");
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;//
    
    [WXApi sendReq:req];
    [self dismiss];
}
//#pragma mark-分享到微信朋友圈
-(void)shareWechatGroup:(UIButton *)sender{
    if (![WXApi isWXAppInstalled]) {
        [[WHTool shareInstance]showALterViewWithOneButton:@"您不能使用分享功能" andMessage:@"您没有安装微信"];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _title;
    message.description = _message;
    [message setThumbImage:[UIImage imageNamed:_thumbImage]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = FORMAT(@"https://m.qunadai.com/land/loginDownload/index.html?channelCode=ShareTest");
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;//
    
    [WXApi sendReq:req];
    [self dismiss];
}

-(void)copyTheLink:(UIButton*)button
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = FORMAT(@"https://m.qunadai.com/land/loginDownload/index.html?channelCode=ShareTest");
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow.maskView makeCenterToast:@"复制成功"];

    [self dismiss];
    
    
}

@end
