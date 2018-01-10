//
//  QNDReplyTextCell.h
//  qunadai
//
//  Created by wang on 2017/11/9.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDProductReplyListModel.h"

@interface QNDReplyTextCell : UITableViewCell

@property (strong,nonatomic)QNDProductReplyListModel * model;

-(void)setModel:(QNDProductReplyListModel *)model;

@end
