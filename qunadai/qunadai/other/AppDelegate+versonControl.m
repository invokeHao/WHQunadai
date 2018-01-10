//
//  AppDelegate+versonControl.m
//  qunadai
//
//  Created by wang on 2017/4/22.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "AppDelegate+versonControl.h"
#import "AppDelegate+loginJudge.h"
#import "QNDVersonControlApi.h"
#import "WHUpdateView.h"

#import "QNDVersonModel.h"

#import "NSString+extention.h"

@implementation AppDelegate (versonControl)

-(void)needToForceUpdate{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    if ([[user objectForKey:KFirstTime] boolValue]) {
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isToSubmit"];//如果要隐藏需改为YES
    }
    QNDVersonControlApi * api = [[QNDVersonControlApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",[request responseJSONObject]);
        BOOL flag = YES;
        BOOL forceUpdate = NO;
        QNDVersonModel * model = nil;
        NSInteger  status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            NSDictionary * dataDic = [request responseJSONObject][@"data"];
            model = [[QNDVersonModel alloc]initWithDictionary:dataDic];
            flag = model.distribution;
            forceUpdate = model.upgradeFlag;
            [[NSUserDefaults standardUserDefaults]setObject:model.customerServiceHotline forKey:KCustomerServiceHotline];//客服联系电话
            [[NSUserDefaults standardUserDefaults] setObject:model.bussContact forKey:KBussContact];//商务联系
            int Version = (int)([appVersion floatValue]*10);
            if (Version< model.versionCode) {
                if (forceUpdate) {
                    [WHUpdateView showTheUpdateViewWithContent:model.upgradeDescription andType:ForceUpdateType];
                }else{
                    [WHUpdateView showTheUpdateViewWithContent:model.upgradeDescription andType:NormalUpdateType];
                }
            }
        }else{
        }
        if (!flag) {
            [user setBool:YES forKey:KFirstTime];
            NOTIF_POST(KNOTIFICATION_SUCCESS, [NSNumber numberWithBool:flag]);
        }
        [user setBool:flag forKey:@"isToSubmit"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}



@end
