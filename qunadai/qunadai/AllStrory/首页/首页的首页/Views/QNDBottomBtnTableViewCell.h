//
//  QNDBottomBtnTableViewCell.h
//  qunadai
//
//  Created by 王浩 on 2017/12/28.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnBlock)();
@interface QNDBottomBtnTableViewCell : UITableViewCell

@property (copy,nonatomic)BtnBlock block;

-(void)setBlock:(BtnBlock)block;

@end
