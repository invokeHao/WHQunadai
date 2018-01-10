//
//  WHStarView.h
//  qunadai
//
//  Created by wang on 2017/9/28.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHStarView : UIView

@property (nonatomic, assign) CGFloat lightPercent;

@end


#import <UIKit/UIKit.h>

typedef  void (^GRTouchedActionBlock)(CGFloat score);

@interface WHStarsView : UIView

@property (nonatomic, assign) BOOL allowSelect;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) BOOL allowDecimal;
@property (nonatomic, assign) BOOL allowDragSelect;

@property (nonatomic, copy) GRTouchedActionBlock touchedActionBlock;

- (instancetype)initWithStarSize:(CGSize)size margin:(CGFloat)margin numberOfStars:(NSInteger)number;
@end
