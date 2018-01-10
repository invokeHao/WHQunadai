//
//  YellowAlertTableViewCell.h
//  qunadai
//
//  Created by wang on 17/3/31.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clearYellowBlock)();
@interface YellowAlertTableViewCell : UITableViewCell

@property (strong,nonatomic)UILabel * alertLabel;

@property (strong,nonatomic)clearYellowBlock yellowBlock;


-(void)setYellowBlock:(clearYellowBlock)yellowBlock;
@end
