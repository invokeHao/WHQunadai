//
//  QNDProCommentDetailViewController.h
//  qunadai
//
//  Created by wang on 2017/10/9.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDProductCommentListModel.h"

typedef void(^replySuccessBlock)(QNDProductReplyListModel * model);

@interface QNDProCommentDetailViewController : UIViewController

@property (strong,nonatomic)QNDProductCommentListModel * commentModel;

@property (copy,nonatomic)replySuccessBlock successBlock;

-(void)setSuccessBlock:(replySuccessBlock)successBlock;

@end
