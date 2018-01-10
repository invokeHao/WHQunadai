//
//  AppDelegate+Bugly.m
//  qunadai
//
//  Created by wang on 17/4/10.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "AppDelegate+Bugly.h"
#import <Bugly/Bugly.h>
#import <Bugtags/Bugtags.h>

#define KBuglyAppId  @"ad41ff32ea"

#if DEBUG
#define KBugtadsAppKey @"305d44079532bd634a3a8dd6821f883b"
#else
#define KBugtadsAppKey @"d45c1fb97a1839e0fca3e424c2ecd757"
#endif



@implementation AppDelegate (Bugly)

-(void)setupBuglyConfig{
    
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
    #if DEBUG
    config.debugMode = YES;
    #endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:KBuglyAppId
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    
    //bugtags
    [self setupBugtags];
}

-(void)setupBugtags{

#if DEBUG
    [Bugtags startWithAppKey:KBugtadsAppKey invocationEvent:BTGInvocationEventNone];
#else
    [Bugtags startWithAppKey:KBugtadsAppKey invocationEvent:BTGInvocationEventNone];
#endif
}



@end
