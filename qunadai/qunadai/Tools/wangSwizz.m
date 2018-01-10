//
//  wang.m
//  qunadai
//
//  Created by wang on 17/3/16.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "wangSwizz.h"
#import <objc/runtime.h>

@implementation NSObject (wangSwizz)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}
@end

@interface UIViewController (wang)

@end

@implementation UIViewController (wang)

+(void)load{
    [self exchangeInstanceMethod1:@selector(viewDidLoad) method2:@selector(wang_viewDidLoad)];
    [self exchangeInstanceMethod1:@selector(viewWillAppear:) method2:@selector(wang_viewWillAppear)];
}

-(void)wang_viewDidLoad{
    [self wang_viewDidLoad];
    WHLog(@"%@",[self class]);
}

-(void)wang_viewWillAppear{
    [self wang_viewWillAppear];
    //判断生产环境不显示
//    if (![BaseUrl isEqualToString:@"https://mapi.qunadai.com"]) {
//        [self showTheFPSLabel];
//    }
}

@end

@implementation YTKBaseRequest (wang)

+(void)load{
    [self exchangeInstanceMethod1:@selector(statusCodeValidator) method2:@selector(wang_statusCodeValidator)];
}

-(BOOL)wang_statusCodeValidator{
   BOOL result = [self wang_statusCodeValidator];
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode==471) {
        result = NO;
        if ([[self currentViewController] isKindOfClass:[UIAlertController class]]) {
            return NO;
        }else if (!KGetACCESSTOKEN){
            return NO;
        }
        [[WHTool shareInstance]showAlterViewWithTitle:@"提示" AndMessage:@"登录过期" andDoneBlock:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUserToken];
        }];
    }else if(statusCode ==500||statusCode == 502||statusCode == 400){
        result = NO;
#if DEBUG
        NSString * errorStr = [NSString stringWithFormat:@"服务器错误\n%ld",statusCode];
#else
        NSString * errorStr = @"系统开小差啦,请稍后~~";
#endif
        if ([[self currentViewController] isKindOfClass:[UIAlertController class]]) {
            return NO;
        }else if(!KGetACCESSTOKEN){
            return NO;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self currentViewController].view makeToast:errorStr];
            });
        }
    }
    return result;
}

- (void)requestDidFailWithRequest:(YTKBaseRequest *)request error:(NSError *)error {
    
}

-(UIViewController *)currentViewController {
    return [self WHTopViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)WHTopViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self WHTopViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self WHTopViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self WHTopViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end



