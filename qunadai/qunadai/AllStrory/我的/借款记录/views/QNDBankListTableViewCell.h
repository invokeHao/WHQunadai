//
//  QNDBankListTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/9/26.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNDBankListTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel * nameLabel;//银行卡名称

@property (strong,nonatomic) UILabel * numberLabel;//银行卡号

-(void)setNumberLabelWithBankNum:(NSString*)bankNum;

@end
