//
//  WangWebViewController.m
//  Yizhenapp
//
//  Created by augbase on 16/5/30.
//  Copyright © 2016年 wang. All rights reserved.
//
#import "WangWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WangWebViewController ()<WKNavigationDelegate,WKUIDelegate>

//@property (strong,nonatomic)
@end

@implementation WangWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cleanTheCookies];
    _webView = [[WKWebView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    _webView.backgroundColor=[UIColor whiteColor];
    _webView.scrollView.backgroundColor=[UIColor whiteColor];
    _webView.navigationDelegate = self;
    
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.5)];
    lineView.backgroundColor=lightGrayBackColor;
    [_webView addSubview:lineView];
    [self.view addSubview: _webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];

//    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://m.qunadai.com/land/land_phone/spclink.html?plid=ef1c4331-0c56-49c7-b0ca-e747e9a38e16"]];

    [_webView loadRequest:request];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self cleanTheCookies];
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setHidden:NO];
    [TalkingData trackPageBegin:_countStr];
    WHLog(@"%@",_url);
    self.title=_webType;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isProduct) {
        _block(_countStr);
    }
    [TalkingData trackPageBegin:_countStr];
}

-(void)cleanTheCookies{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet * types = [NSSet setWithArray:@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]];
        NSDate * dateFrom = [NSDate date];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:dateFrom completionHandler:^{
            WHLog(@"clean the cache");
        }];
    }else{
        NSString * libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString * cookiesPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesPath error:nil];
    }
}



//保证可以跳转到apstore
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    
//    NSURL *url = [NSURL URLWithString:@"http://www.testurl.com:8080/subpath/subsubpath?uid=123&gid=456"];
//    [url scheme]为http,  [url host]为www.testurl.com，[url port]为8080，[url path]为/subpath/subsubpath，[url lastPathComponent]为subsubpath，[url query]为uid=123&gid=456

    WHLog(@"URL====%@",navigationAction.request.URL);

    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    /* 判断itunes的host链接 */
    if([[navigationAction.request.URL host] isEqualToString:@"itunes.apple.com"] &&
       
       [[UIApplication sharedApplication] openURL:navigationAction.request.URL]){
        
        policy =WKNavigationActionPolicyCancel;}
    
    decisionHandler(policy);
}

//支持js的提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
        
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//支持js选择框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
        
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//支持js输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.text = defaultText;
        
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields[0].text?:@"");
        
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
