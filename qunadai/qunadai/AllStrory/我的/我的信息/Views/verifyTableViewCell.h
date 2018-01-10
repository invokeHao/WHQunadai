//
//  verifyTableViewCell.h
//  qunadai
//
//  Created by wang on 17/3/30.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyFunctionModel.h"

@interface verifyTableViewCell : UITableViewCell

@property (strong,nonatomic) UIImageView * iconView;

@property (strong,nonatomic) UILabel * titlelabel;

//@property (strong,nonatomic) UILabel * detailLabel;

@property (strong,nonatomic) UIButton * verifyBtn;

@property (strong,nonatomic) VerifyFunctionModel * model;


-(void)setModel:(VerifyFunctionModel *)model;


@end
