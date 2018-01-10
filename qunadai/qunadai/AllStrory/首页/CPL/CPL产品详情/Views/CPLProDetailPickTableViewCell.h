//
//  CPLProDetailPickTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^valueBlock)(NSString * valueStr);
typedef void(^dateBlock)(NSString * dateStr);

#import "CPLProductModel.h"

@interface CPLProDetailPickTableViewCell : UITableViewCell

@property (strong,nonatomic)valueBlock valueB;

@property (strong,nonatomic)dateBlock dateB;

@property (copy,nonatomic)CPLProductModel * model;

-(void)setValueB:(valueBlock)valueB;

-(void)setDateB:(dateBlock)dateB;

@end
