//
//  QNDDetailProTopTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/9/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productLoanModel.h"
#import "WHStarView.h"

@interface QNDDetailProTopTableViewCell : UITableViewCell

@property (strong,nonatomic)UIImageView * productAvatarV;

@property (strong,nonatomic)UILabel * productNameLabel;

@property (strong,nonatomic)UILabel * productvalueLabel; //额度label

@property (strong,nonatomic)UILabel * productSuccessLabel;//成功人数

@property (strong,nonatomic)UILabel * productRateLabel;//利率label

@property (strong,nonatomic)UILabel * productTimeLabel;//放款时间

@property (strong,nonatomic)WHStarsView * starView ;

@property (strong,nonatomic)productLoanModel * model;

-(void)setModel:(productLoanModel *)model;

@end
