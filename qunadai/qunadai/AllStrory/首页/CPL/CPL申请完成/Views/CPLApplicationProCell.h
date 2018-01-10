//
//  CPLApplicationProCell.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLApplicationDetailModel.h"

@interface CPLApplicationProCell : UITableViewCell

@property (strong,nonatomic)CPLApplicationDetailModel * model;

-(void)setModel:(CPLApplicationDetailModel *)model;

@end
