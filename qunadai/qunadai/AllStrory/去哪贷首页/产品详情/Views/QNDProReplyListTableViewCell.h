//
//  QNDProReplyListTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/10/9.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDProductReplyListModel.h"

@interface QNDProReplyListTableViewCell : UITableViewCell

@property (strong,nonatomic)UIImageView * iconView;

@property (strong,nonatomic)UILabel * contentLabel;

@property (strong,nonatomic)UILabel * dateLabel;

@property (strong,nonatomic)QNDProductReplyListModel * model;

-(void)setModel:(QNDProductReplyListModel *)model;

@end
