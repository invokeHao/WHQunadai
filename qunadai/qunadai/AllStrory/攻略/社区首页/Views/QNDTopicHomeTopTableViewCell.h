//
//  QNDTopicHomeTopTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/11/14.
//  Copyright © 2017年 Hebei Yulan Investment Management Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HelpBlock)();

typedef void(^CreditBlock)();


@interface QNDTopicHomeTopTableViewCell : UITableViewCell


@property (strong,nonatomic)HelpBlock hBlock;

@property (strong,nonatomic)CreditBlock cBlock;


-(void)setHBlock:(HelpBlock)hBlock;

-(void)setCBlock:(CreditBlock)cBlock;

@end
