//
//  AppDelegate+loginJudge.m
//  qunadai
//
//  Created by wang on 17/3/22.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.

#import "AppDelegate+loginJudge.h"
#import "ControlAllNavigationViewController.h"
#import "QNDLoginViewController.h"
#import "GuideViewController.h"
#import "wangTabBarController.h"

@implementation AppDelegate (loginJudge)

-(void)judgeToLogin{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatueChanged:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    NSUserDefaults * User = [NSUserDefaults standardUserDefaults];
    BOOL showGuide = [[User objectForKey:@"showGuide"] boolValue];//判断是否显示引导页
//    showGuide = NO;
    if (!showGuide) {
        self.window.rootViewController = [[ControlAllNavigationViewController alloc]initWithRootViewController:[GuideViewController new]];
        [User setObject:@YES forKey:@"showGuide"];
    }else{
        NSNumber * loginObject = [NSNumber numberWithBool:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:loginObject];
    }
}

-(void)loginStatueChanged:(NSNotification*)notification{
    ControlAllNavigationViewController * allNavVC = nil;
    //自动登录
    if ([notification.object boolValue]) {
        if (self.mainVC==nil) {
            self.mainVC = [[wangTabBarController alloc]init];
            allNavVC = [[ControlAllNavigationViewController alloc]initWithRootViewController:self.mainVC];
        }else{
        allNavVC=(ControlAllNavigationViewController*)self.mainVC.navigationController;
        }
    }else{
        //如果存在mainVC，需要先清除
        if (self.mainVC) {
            [self.mainVC.navigationController popToRootViewControllerAnimated:NO];
            self.mainVC=nil;
        }
        allNavVC = [[ControlAllNavigationViewController alloc]initWithRootViewController:[QNDLoginViewController new]];
    }
    self.window.rootViewController=allNavVC;
}
@end
