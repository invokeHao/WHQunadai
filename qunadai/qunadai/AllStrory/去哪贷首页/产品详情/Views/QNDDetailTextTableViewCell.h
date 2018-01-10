//
//  QNDDetailTextTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/9/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productLoanModel.h"

@interface QNDDetailTextTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel * successRateLabel;//成功率

@property(strong,nonatomic)UILabel * passAmountLabel; //通过人数

@property(strong,nonatomic)UILabel * avgValueLabel; //平均额度

@property(strong,nonatomic)productLoanModel * model;

-(void)setModel:(productLoanModel *)model;

@end
