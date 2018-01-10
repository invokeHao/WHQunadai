//
//  QNDSamllCardTableViewCell.h
//  qunadai
//
//  Created by 王浩 on 2017/12/28.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNDSamllCardTableViewCell : UITableViewCell

@property (strong,nonatomic)UILabel * valueLabel;

-(void)setAmount:(NSInteger)amount;

@end
