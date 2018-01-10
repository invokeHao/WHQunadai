//
//  WHTool.h
//  qunadai
//
//  Created by wang on 17/3/23.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface WHTool : NSObject

+ ( WHTool * _Nonnull )shareInstance;

-(void)setupNavigationLeftButton:(UIViewController *)viewController LeftButton:(UIButton * _Nonnull)leftButton;
//设置navigationBar右按钮
-(void)setupNavigationRightButton:(UIViewController * _Nonnull)viewController RightButton:(UIButton * _Nonnull)rightButton;

-(void)showAlterViewWithMessage:(NSString * _Nonnull )message andDoneBlock:(void(^ _Nonnull)(UIAlertAction * _Nonnull action))doneBlock;

-(void)showALterViewWithOneButton:(NSString * _Nonnull)title andMessage:(NSString * _Nonnull)message;

-(void)showAlterViewWithTitle:(NSString*_Nonnull)title AndMessage:(NSString*_Nonnull)message andDoneBlock:(void(^_Nonnull)(UIAlertAction * _Nonnull action))doneBlock;

//获取权限的提示框
-(void)showAlterViewWithTitle:(NSString*_Nonnull)title Message:(NSString*_Nonnull)message cancelBtn:(NSString*_Nonnull)cancelTitle doneBtn:(NSString*_Nonnull)doneTitle andVC:(UIViewController * _Nonnull)VC andDoneBlock:(void(^_Nonnull)(UIAlertAction * _Nonnull action))doneBlock andCancelBlock:(void(^_Nonnull)(UIAlertAction * _Nonnull action))cancelBlock;

-(void)showTextHUD:(UIViewController * _Nonnull)viewController Title:(NSString * _Nonnull)title;


-(void)showActionSheetWithTitle1:(NSString *_Nonnull)title1 andTitle2:(NSString * _Nonnull)title2 withActionBlock1:(void(^_Nonnull)(UIAlertAction * _Nonnull action))action1 andActionBlock2:(void(^_Nonnull)(UIAlertAction * _Nonnull action) )action2;

-(void)WHTopViewController;

-(void)GoToLoginWithFromVC:(UIViewController * _Nonnull)viewController;

#pragma mark- 颜色转图片啊
- (UIImage * _Nonnull)imageFromColor:(UIColor * _Nonnull)color;

#pragma mark-网络请求部分
- (void)GetDataFromApi:(YTKRequest* _Nonnull)Api andCallBcak:(void(^_Nonnull)(NSDictionary* dic))callback;

@end
