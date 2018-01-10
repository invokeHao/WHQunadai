//
//  UITextView+WH.h
//  qunadai
//
//  Created by wang on 2017/7/18.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^textViewHeightWillChangedBlock)(CGFloat currentTextViewHeight);

@interface UITextView (WH)

//等待文字
@property (nonatomic,copy) NSString * placeholder;
//占位文字的颜色
@property (nonatomic,strong) UIColor * placeholderColor;
//最大高度
@property (nonatomic,assign) CGFloat maxHeight;
//最小高度
@property (nonatomic,assign) CGFloat minHeight;
//最后一次高度
@property (nonatomic,assign) CGFloat lastHeight;
//回掉的blcok
@property (nonatomic,strong) textViewHeightWillChangedBlock heightChangedBlock;

/* 自动高度的方法，maxHeight：最大高度 */
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight;
/* 自动高度的方法，maxHeight：最大高度， textHeightDidChanged：高度改变的时候调用 */
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(textViewHeightWillChangedBlock)heightDidChangedBlock;

@end
