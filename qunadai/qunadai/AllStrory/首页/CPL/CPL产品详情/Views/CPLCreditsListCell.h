//
//  CPLCreditsListCell.h
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLCreditListModel.h"

@interface CPLCreditsListCell : UITableViewCell

@property (strong,nonatomic)CPLCreditListModel * model;

-(void)setModel:(CPLCreditListModel *)model;

@end
