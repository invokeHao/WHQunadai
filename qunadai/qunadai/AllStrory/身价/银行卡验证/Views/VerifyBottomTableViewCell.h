//
//  VerifyBottomTableViewCell.h
//  qunadai
//
//  Created by wang on 17/3/31.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^verifyBlock)();

typedef void(^RuleBlock)();

@interface VerifyBottomTableViewCell : UITableViewCell

@property (strong,nonatomic)verifyBlock vBlcok;

@property (strong,nonatomic)RuleBlock rBlock;


-(void)setVBlcok:(verifyBlock )vBlcok;


-(void)setRBlock:(RuleBlock)rBlock;

@end
