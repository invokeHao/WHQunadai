//
//  MineInfoTableViewCell.h
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"

typedef void(^GetValueBlock)();
typedef void(^UserCountBlock)();

@interface MineInfoTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel * nameLabel;

@property (strong,nonatomic) UIButton * avatarBtn;

@property (strong,nonatomic) UIButton * valueBtn;//获取额度

@property (strong,nonatomic)AccountModel * model;

@property (copy,nonatomic)GetValueBlock valueB;

@property (copy,nonatomic)UserCountBlock userB;


-(void)setValueB:(GetValueBlock)valueB;

-(void)setUserB:(UserCountBlock)userB;


-(void)setModel:(AccountModel *)model;


@end
