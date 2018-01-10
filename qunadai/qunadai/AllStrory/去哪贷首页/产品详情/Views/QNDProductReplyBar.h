//
//  QNDProductReplyBar.h
//  qunadai
//
//  Created by wang on 2017/9/29.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHTextView.h"

@protocol ProReplyBarDelegate <NSObject>

-(void)PostTheReplyWithContent:(NSString*)content;

@end

@interface QNDProductReplyBar : UIView

@property (strong,nonatomic)WHTextView * inputText;

@property (strong,nonatomic)UILabel * pleaseholderLabel;

@property (weak,nonatomic)id<ProReplyBarDelegate> delegate;

@end
