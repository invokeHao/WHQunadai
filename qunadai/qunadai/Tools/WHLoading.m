//
//  WHLoading.m
//  qunadai
//
//  Created by wang on 17/4/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "WHLoading.h"
#import <MBProgressHUD.h>

@interface WHLoading ()
{
    UIImageView * imageV;
}
@property (strong,nonatomic)MBProgressHUD * MBhud;

@end

@implementation WHLoading

+(WHLoading *)ShareInstance{
    static WHLoading *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)showImageHUD:(UIView*)view
{
    _MBhud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    _MBhud.bezelView.color =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3f];
    _MBhud.mode=MBProgressHUDModeCustomView;
    UIImageView * imageBackV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading_bg"]];
    [imageBackV setFrame:CGRectMake(0, 0, 34, 34)];
    
    UIImageView * loadV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading"]];
    loadV.center = imageBackV.center;
    loadV.bounds = CGRectMake(0, 0, 23, 23);
    [imageBackV addSubview:loadV];
    
    _MBhud.customView=imageBackV;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation *rotationAnim = [CABasicAnimation animation];
        rotationAnim.keyPath = @"transform.rotation.z";
        rotationAnim.toValue = @(2 * M_PI);
        rotationAnim.repeatCount = MAXFLOAT;
        rotationAnim.duration = 2;
        rotationAnim.cumulative = NO;//无限循环
        [loadV.layer addAnimation:rotationAnim forKey:nil];
    });
    
}

-(void)hidenHud{
    [_MBhud setHidden:YES];
}


-(BOOL)isShowingHud{
    return !_MBhud.isHidden;
}



@end
