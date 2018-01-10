//
//  QNDMineReplyTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDMineReplyModel.h"

@interface QNDMineReplyTableViewCell : UITableViewCell

@property (strong,nonatomic)UIImageView * proIconView;

@property (strong,nonatomic)UILabel * nameLabel;

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)UIImageView * contentBackView;

@property (strong,nonatomic)UILabel * contentLabel;

@property (strong,nonatomic)QNDMineReplyModel * model;

-(void)setModel:(QNDMineReplyModel *)model;

@end
