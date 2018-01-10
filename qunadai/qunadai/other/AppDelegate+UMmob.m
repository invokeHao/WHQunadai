//
//  AppDelegate+UMmob.m
//  qunadai
//
//  Created by wang on 2017/5/3.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "AppDelegate+UMmob.h"

#import "TalkingData.h"


@implementation AppDelegate (UMmob)

- (void)umengTrack {
    //talkingData注册
    [TalkingData sessionStarted:@"7D3DFD52853E4A478BBFC3B3C1B30C27" withChannelId:@"app store"];
    //注册微信
    [WXApi registerApp:WXAppId];
}


#pragma mark-微信回调
//授权后回调 WXApiDelegate
-(void)onResp:(BaseResp *)resp{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"去哪贷分享结果"];
        SendAuthResp *aresp = (SendAuthResp *)resp;
        NSString *strMsg;
        if (aresp.errCode == 0) {
            strMsg = NSLocalizedString(@"分享成功！", @"");
        }else{
            strMsg = NSLocalizedString(@"分享失败！", @"");
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([resp isKindOfClass:[PayResp class]])
    {
        NSString *BtnStr,*strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"已经支付成功";
                BtnStr=@"继续";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                //发送通知
                //                NSNotificationCenter*center=[NSNotificationCenter defaultCenter];
                //                [center postNotificationName:KWXPaySuccess object:nil];
            }
                break;
            case WXErrCodeUserCancel:
                strMsg =@"用户取消支付";
                BtnStr=@"返回";
                NSLog(@"支付取消－PayCancel，retcode = %d", resp.errCode);
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                BtnStr=@"返回";
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:BtnStr otherButtonTitles:nil, nil];
        [alert show];
    }else{
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatLoginCode" object:self userInfo:dic];
        }
    }
}


@end
