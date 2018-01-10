//
//  TopicHomeTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/5/12.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicMainModel.h"

@interface TopicHomeTableViewCell : UITableViewCell

@property (strong,nonatomic)TopicMainModel * model;

-(void)setModel:(TopicMainModel *)model;

@end
