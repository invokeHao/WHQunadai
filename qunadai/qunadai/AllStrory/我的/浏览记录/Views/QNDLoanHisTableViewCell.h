//
//  QNDLoanHisTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/9/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productLoanModel.h"

@interface QNDLoanHisTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel * nameLabel;

@property (strong,nonatomic) UILabel * timeLabel; //浏览时间label

@property (strong,nonatomic) UILabel * valueLabel;//额度label

@property (strong,nonatomic) UILabel * fastLabel;

@property (strong,nonatomic) UILabel * dateLabel;

@property (strong,nonatomic) UILabel * inspectLabel;//查看label

@property (strong,nonatomic) productLoanModel * model;


-(void)setModel:(productLoanModel *)model;

@end
