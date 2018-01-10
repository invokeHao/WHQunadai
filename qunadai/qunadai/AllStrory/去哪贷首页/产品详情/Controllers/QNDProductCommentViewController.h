//
//  QNDProductCommentViewController.h
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productLoanModel.h"

typedef void(^CommentSuccessBlock)();

@interface QNDProductCommentViewController : UIViewController

@property (strong,nonatomic)productLoanModel * productModel;

@property (strong,nonatomic)CommentSuccessBlock SuccessBlock;

-(void)setSuccessBlock:(CommentSuccessBlock)SuccessBlock;

@end
