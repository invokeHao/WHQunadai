//
//  WHAnnouncementLabel.h
//  qunadai
//
//  Created by wang on 2017/11/27.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHAnnouncementLabel : UIView

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, assign) CGFloat speed;//0.1~0.5  默认是0.3
/*!
 *
 * @abstract start animation
 */
- (void)startAnimation;
/*!
 *
 * @abstract stop animation
 */
- (void)stopAnimation;


@end
