//
//  wangTabBarController.m
//  Yizhenapp
//
//  Created by augbase on 16/5/11.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "wangTabBarController.h"
#import "UITabBar+badge.h"
#import "QndHomePageViewController.h"
#import "TopicHomePViewController.h"
#import "QNDMineHPViewController.h"
#import "TopicHomePageViewController.h"
#import "QNDLoanHomeViewController.h"
#import "CalculaterViewController.h"
#import "QNDValueHomePViewController.h"
#import "QNDNewHomePageViewController.h"


@interface wangTabBarController ()
@end

@implementation wangTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView*V=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 49)];
    UIColor*color=[UIColor colorWithPatternImage:[UIImage imageNamed:@"MemoResources.bundle/tabbar_background"]];
    V.backgroundColor=color;
    [self.tabBar insertSubview:V atIndex:0];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setShadowImage:[UIImage alloc]];
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置

    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    attrs[NSForegroundColorAttributeName] = QNDRGBColor(158, 158, 158);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = black31TitleColor;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [self setUpTheChildVCS];
    //接受通知
    NOTIF_ADD(KNOTIFICATION_SUCCESS, changeTheChildVC);
    
    NOTIF_ADD(KNOTIFICATION_APPLICATION, showTheRedPoint:);
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    UIImage* imageNormal = [UIImage imageNamed:image];
    UIImage* imageSelected = [UIImage imageNamed:selectedImage];
    vc.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.title = title;
    // 添加为子控制器
    [self addChildViewController:vc];
}

-(void)setUpTheChildVCS{
    // 添加子控制器
    if (KWHSUCCESS) {
        QNDLoanHomeViewController * loanVC = [[QNDLoanHomeViewController alloc]init];
        [self setupChildVc:loanVC title:@"借款" image:@"tab_icon_gold" selectedImage:@"tab_icon_press gold"];
        
        [self setupChildVc:[[QNDValueHomePViewController alloc] init] title:@"信息" image:@"tab_icon_find" selectedImage:@"tab_icon_press find"];
        
        [self setupChildVc:[[QNDMineHPViewController alloc] init] title:@"我的" image:@"tab_icon_me" selectedImage:@"tab_icon_press me"];
    }else{
        [self setupChildVc:[[QNDNewHomePageViewController alloc] init] title:@"贷款" image:@"tab_icon_gold" selectedImage:@"tab_icon_press_vip"];
        
        [self setupChildVc:[[QndHomePageViewController alloc]init] title:@"贷款超市" image:@"tab_icon_market" selectedImage:@"tab_icon_press_market"];
        
        [self setupChildVc:[[TopicHomePageViewController alloc] init] title:@"发现" image:@"tab_icon_find" selectedImage:@"tab_icon_press find"];
        
        [self setupChildVc:[[QNDMineHPViewController alloc] init] title:@"我的" image:@"tab_icon_me" selectedImage:@"tab_icon_press_me"];
    }
}

-(void)changeTheChildVC{
    //判断一下第一个子控制器是否需要
    if ([self.viewControllers.firstObject isMemberOfClass:[QNDNewHomePageViewController class]]) {
        return;
    }
    if (self.viewControllers.count<1) {
        return;
    }
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj willMoveToParentViewController:nil];
        [obj.view removeFromSuperview];
        [obj removeFromParentViewController];
    }];
    //清除tabbar上的title和iamges
    
    QNDNewHomePageViewController * newVC = [[QNDNewHomePageViewController alloc] init];
    [self setupChildVc:newVC title:@"贷款" image:@"tab_icon_gold" selectedImage:@"tab_icon_press_vip"];
    [newVC didMoveToParentViewController:self];
    self.selectedViewController = newVC;

    QndHomePageViewController * qndVC = [QndHomePageViewController new];
    [self setupChildVc:qndVC title:@"去哪贷" image:@"tab_icon_gold" selectedImage:@"tab_icon_press gold"];
    [qndVC didMoveToParentViewController:self];
    
    TopicHomePageViewController * topicVC = [[TopicHomePageViewController alloc]init];
    [self setupChildVc:topicVC title:@"发现" image:@"tab_icon_find" selectedImage:@"tab_icon_press find"];
    [topicVC didMoveToParentViewController:self];
    
    QNDMineHPViewController * mineVC = [[QNDMineHPViewController alloc]init];
    [self setupChildVc:mineVC title:@"我" image:@"tab_icon_me" selectedImage:@"tab_icon_press_me"];
    [mineVC didMoveToParentViewController:self];
}

-(void)showTheRedPoint:(NSNotification*)notification{
    BOOL haveNewMessage = [[notification object] boolValue];
    if (haveNewMessage) {
        [self.tabBar showBadgeOnItemIndex:3];
    }else{
        [self.tabBar hideBadgeOnItemIndex:3];
    }
}


@end
