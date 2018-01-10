//
//  CPLApplicationDetailViewController.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLProductModel.h"

@interface CPLApplicationDetailViewController : UIViewController

@property (strong,nonatomic)CPLProductModel * proModel;

@property (copy,nonatomic)NSString * application_id;//申请id

@end
