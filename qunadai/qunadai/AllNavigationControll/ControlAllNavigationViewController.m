//
//  ControlAllNavigationViewController.m
//  Yizhenapp
//
//  Created by wang on 15/11/17.
//  Copyright © 2015年 wang. All rights reserved.
//

#import "ControlAllNavigationViewController.h"

@interface ControlAllNavigationViewController ()

@end

@implementation ControlAllNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

-(void)setupNavigationBar{
    
    UIImage*image=[UIImage imageNamed:@"icon_back"];
    [[UINavigationBar appearance] setBackIndicatorImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:248.0/255.0 green:250.0/255.0 blue:251.0/255.0 alpha:1.0]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:248.0/255.0 green:250.0/255.0 blue:251.0/255.0 alpha:1.0]];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(16);
    attrs[NSForegroundColorAttributeName] = black31TitleColor;

    [[UINavigationBar appearance] setTitleTextAttributes:attrs];
    
    //   遍历获取字体名称
//        NSArray * arr = [UIFont familyNames];
//        for(NSString *fontFamilyName in [UIFont familyNames])
//        {
//            WHLog(@"family:'%@'",fontFamilyName);
//            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName])
//            {
//                WHLog(@"\tfont:'%@'",fontName);
//            }
//            WHLog(@"-------------");
//        }
    
}

- (BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}




@end
