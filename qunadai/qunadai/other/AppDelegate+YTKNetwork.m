//
//  AppDelegate+YTKNetwork.m
//  qunadai
//
//  Created by wang on 17/3/16.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "AppDelegate+YTKNetwork.h"
#import "YTKUrlArgumentsFilter.h"
#import <AvoidCrash.h>


@implementation AppDelegate (YTKNetwork)

-(void)setUpYTKNetwork{

//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    YTKNetworkConfig * config = [YTKNetworkConfig sharedConfig];
//    //这一步为给所有的请求加入版本号
//    YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"version": appVersion}];
//    [config addUrlFilter:urlFilter];
    //等baseURl和CDN
    config.baseUrl = BaseUrl;
    
    
    
    //AvoidCrach 设置
    [AvoidCrash becomeEffective];
    //信息收集
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}


- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
}




@end
