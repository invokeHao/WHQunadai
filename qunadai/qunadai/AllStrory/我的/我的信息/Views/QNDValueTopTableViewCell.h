//
//  QNDValueTopTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/9/12.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rankView.h"

@interface QNDValueTopTableViewCell : UITableViewCell


@property (strong,nonatomic)UILabel * valueLabel;//积分值的label

-(void)setTheLoanValue:(NSString*)value; 

@end
