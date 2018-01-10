//
//  loanProductTableViewCell.h
//  qunadai
//
//  Created by wang on 17/4/1.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productLoanModel.h"

typedef void(^OrderBlock)(NSString * pid,NSString * name);
typedef void(^DirectApplyBlock)(NSString * name,NSString * url,NSString * pid);

@interface loanProductTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel * nameLabel;

@property (strong,nonatomic)productLoanModel * model;

@property (strong,nonatomic)OrderBlock orderB;

@property (copy,nonatomic)DirectApplyBlock applyB;

-(void)setOrderB:(OrderBlock)orderB;

-(void)setApplyB:(DirectApplyBlock)applyB;

-(void)setModel:(productLoanModel *)model;

@end
