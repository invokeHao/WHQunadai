//
//  CPLProductDetailViewController.h
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLProductModel.h"

typedef enum : NSUInteger {
    CPlDEfalut,
    CPLPhoneVerify,
    CPLZhiMaVerify,
    CPLExtra1Verify,
    CPLEXtra2Verify
} CPLVerifyType;


@interface CPLProductDetailViewController : UIViewController

@property (strong,nonatomic) CPLProductModel * model;


@end
