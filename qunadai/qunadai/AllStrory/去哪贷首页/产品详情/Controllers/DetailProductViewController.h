//
//  DetailProductViewController.h
//  qunadai
//
//  Created by wang on 17/4/5.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "productLoanModel.h"

typedef void(^backBlock)(NSString * pid);

@interface DetailProductViewController : UIViewController

@property (copy,nonatomic)NSString * productCode;

@property (copy,nonatomic)NSString * productId;//产品id

@property (copy,nonatomic)NSString * expectLoanValue;//预期还款金额

@property (copy,nonatomic)NSString * expectLoanDate;//预期还款时间

@property (assign,nonatomic)BOOL needBack;//需要显示申请产品的弹窗吗？

@property (strong,nonatomic)productLoanModel * model;

@end
