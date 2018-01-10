//
//  CPLProductListTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLProductModel.h"

@interface CPLProductListTableViewCell : UITableViewCell

@property (copy,nonatomic)CPLProductModel * model;

-(void)setModel:(CPLProductModel *)model;

-(void)ShowTheApplicationStatus:(BOOL)status;

@end
