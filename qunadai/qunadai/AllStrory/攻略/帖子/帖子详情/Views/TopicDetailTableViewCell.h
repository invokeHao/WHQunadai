//
//  TopicDetailTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/5/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

typedef void(^ThumbBlock)();

#import <UIKit/UIKit.h>

#import "TopicMainModel.h"


@interface TopicDetailTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel * titleLabel;

@property (strong,nonatomic) TopicMainModel * model;

-(void)setModel:(TopicMainModel *)model;


@end
