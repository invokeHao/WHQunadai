//
//  WHJSWebViewController.m
//  qunadai
//
//  Created by wang on 2017/11/9.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "WHJSWebViewController.h"

@interface WHJSWebViewController ()<WKScriptMessageHandler,WKUIDelegate>

@property (strong, nonatomic)WKWebView * webView;

@end

@implementation WHJSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cleanTheCookies];
    [self initWKWebView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = _titleName;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//初始化页面
- (void)initWKWebView
{
    //进行配置控制器
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //实例化对象
    configuration.userContentController = [WKUserContentController new];
    
    //调用JS方法
    [configuration.userContentController addScriptMessageHandler:self name:@"FinishAction"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_Url]];
    [self.webView loadRequest:request];
    
    WHLog(@"%@",_Url);
    
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //    message.body  --  Allowed types are NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull.
    NSLog(@"body:%@",message.body);
    NSLog(@"name:%@",message.name);
    if ([message.name isEqualToString:@"FinishAction"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//保证可以跳转到apstore
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
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


@end
