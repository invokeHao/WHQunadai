//
//  WHTool.m
//  qunadai
//
//  Created by wang on 17/3/23.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "WHTool.h"
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "QNDLoginViewController.h"

@interface WHTool ()

@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation WHTool

+(WHTool *)shareInstance{
    static WHTool * ToolInstance =nil;
    static dispatch_once_t predicate ;
    dispatch_once(&predicate, ^{
        ToolInstance = [[self alloc]init];
    });
    return ToolInstance;
}

#pragma maark- navigationBar的设置

-(void)setupNavigationRightButton:(UIViewController *)viewController RightButton:(UIButton *)rightButton{
    [viewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton]];
}

-(void)setupNavigationLeftButton:(UIViewController *)viewController LeftButton:(UIButton *)leftButton{
    [viewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
}

-(void)setupNavigationView:(UINavigationController *)navigation Image:(UIImage *)image{
    navigation.navigationBarHidden = NO;
// 去掉navigationbar下划线
    UINavigationBar *navigationBar = navigation.navigationBar;
    [navigationBar setBackgroundImage:image
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    navigation.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
    [navigation.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],NSForegroundColorAttributeName,nil]];
    navigation.navigationBar.tintColor = [UIColor greenColor];
    [navigation.navigationBar setBackgroundImage:image forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
}


//警告框确定和取消
-(void)showAlterViewWithMessage:(NSString*)message andDoneBlock:(void(^)(UIAlertAction * _Nonnull action))doneBlock{
    UIAlertController * alterC = [UIAlertController alertControllerWithTitle:nil message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"hadShow"];
    }];
    UIAlertAction * doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:doneBlock];
    alterC.view.tintColor=ThemeColor;
    [alterC addAction:cancelAction];
    [alterC addAction:doneAction];
    @try {
        [[WHTool WHTopViewController] presentViewController:alterC animated:YES completion:nil];
    } @catch (NSException *exception) {
        
    } @finally {
    }
}
//警告框确定并执行操作
-(void)showAlterViewWithTitle:(NSString*)title AndMessage:(NSString*)message andDoneBlock:(void(^)(UIAlertAction * _Nonnull action))doneBlock{
    UIAlertController * alterC = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:doneBlock];
    alterC.view.tintColor=ThemeColor;
    [alterC addAction:doneAction];
    @try {
        [[WHTool WHTopViewController] presentViewController:alterC animated:YES completion:nil];
    } @catch (NSException *exception) {
        
    } @finally {
    }

}
//警告框只有一个按钮
-(void)showALterViewWithOneButton:(NSString *)title andMessage:(NSString*)message{
    UIAlertController * alterVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    alterVC.view.tintColor=ThemeColor;
    [alterVC addAction:cancel];
    @try {
        [[WHTool WHTopViewController] presentViewController:alterVC animated:YES completion:nil];
    } @catch (NSException *exception) {
        
    } @finally {
    }
}

//获取权限的提示框
-(void)showAlterViewWithTitle:(NSString*)title Message:(NSString*)message cancelBtn:(NSString*)cancelTitle doneBtn:(NSString*)doneTitle andVC:(UIViewController * _Nonnull)VC andDoneBlock:(void(^)(UIAlertAction * _Nonnull action))doneBlock andCancelBlock:(void(^)(UIAlertAction * _Nonnull action))cancelBlock{
    UIAlertController * alterC = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:cancelBlock];
    
    UIAlertAction * doneAction = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDestructive handler:doneBlock];
    
    [alterC addAction:cancelAction];
    [alterC addAction:doneAction];
    alterC.view.tintColor = black74TitleColor;
    @try {
        [VC presentViewController:alterC animated:YES completion:nil];
    } @catch (NSException *exception) {
    } @finally {
    }
}

//弹出框封装
-(void)showActionSheetWithTitle1:(NSString*)title1 andTitle2:(NSString*)title2 withActionBlock1:(void(^)(UIAlertAction * _Nonnull action))action1 andActionBlock2:(void(^)(UIAlertAction * _Nonnull action) )action2{
    UIAlertController * alterVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * alert1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:action1];
    UIAlertAction * alert2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:action2];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    alterVC.view.tintColor=ThemeColor;
    [alterVC addAction:alert1];
    [alterVC addAction:alert2];
    [alterVC addAction:cancel];
    
    [[WHTool WHTopViewController] presentViewController:alterVC animated:YES completion:nil];
}

//模仿安卓的toast
-(void)showTextHUD:(UIViewController*)viewController Title:(NSString*)title{
    _HUD=[MBProgressHUD showHUDAddedTo:viewController.view animated:YES];

    _HUD.label.textColor =[UIColor whiteColor];
    _HUD.label.font = [UIFont systemFontOfSize:16.0];
    _HUD.label.text = title;
    _HUD.bezelView.backgroundColor = [UIColor blackColor];
    _HUD.mode=MBProgressHUDModeText;
    _HUD.removeFromSuperViewOnHide=YES;
    [_HUD hideAnimated:YES afterDelay:1.6];
}

-(void)GoToLoginWithFromVC:(UIViewController *)viewController{
    if ([viewController isMemberOfClass:[QNDLoginViewController class]]) {
        return;
    }
    QNDLoginViewController *vcLogin = [[QNDLoginViewController alloc] init];
    UINavigationController *vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcLogin];
    [viewController presentViewController:vcNavigation animated:YES completion:nil];
}
// 颜色转图片
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//网络请求的返回封装
-(void)GetDataFromApi:(YTKRequest *)Api andCallBcak:(void (^)(NSDictionary *))callback{
    [Api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        WHLog(@"%@",Api.class);
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status == 1) {
            NSDictionary * dic = [request responseJSONObject][@"data"];
            WHLog(@"%@",dic);
            callback(dic);
        }else if (status==-1){
            [self GoToLoginWithFromVC:[WHTool WHTopViewController]];
        }else {
            [[WHTool WHTopViewController].view makeToast:[request responseJSONObject][@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}
//获取当前VC
+ (UIViewController *)WHTopViewController{
    return [WHTool WHTopViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)WHTopViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [WHTool WHTopViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [WHTool WHTopViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [WHTool WHTopViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


@end
