//
//  WangWebViewController.h
//  Yizhenapp
//
//  Created by augbase on 16/5/30.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void(^ProBlock)(NSString * pName);

@interface WangWebViewController : UIViewController
{
    NSString*actionType;//控制函数
    NSString*actionCallback;//回调函数
    WKWebView *_webView;
}
@property (nonatomic,strong) NSString *url;//传入的页面url
@property (nonatomic,strong) NSString*webType;

@property (nonatomic,assign) BOOL isProduct;//返回弹框

@property (nonatomic,strong) NSString * countStr;//统计内容

@property (nonatomic,strong) ProBlock block;

-(void)setBlock:(ProBlock)block;

@end
