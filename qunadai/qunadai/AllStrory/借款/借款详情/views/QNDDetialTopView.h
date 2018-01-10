//
//  QNDDetialTopView.h
//  qunadai
//
//  Created by wang on 2017/9/25.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNDDetialTopView : UIView

@property (strong,nonatomic)UILabel * valueLabel;

@property (strong,nonatomic)UILabel * payMonthLabel;

-(instancetype)initWithValueStr:(NSString*)valueStr;

@end
