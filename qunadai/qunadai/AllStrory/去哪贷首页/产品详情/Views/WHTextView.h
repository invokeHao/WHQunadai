//
//  WHTextView.h
//  qunadai
//
//  Created by wang on 2017/11/1.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHTextView;
@protocol WHTextViewDelegate <UITextViewDelegate>

- (void)textViewDeleteBackward:(WHTextView *)textView;

@end

@interface WHTextView : UITextView

@property(nonatomic ,weak) id<WHTextViewDelegate> delegate;

@property (nonatomic, copy) NSString * placeHolder;

@property (nonatomic, strong) UIColor * placeHolderTextColor;

- (NSUInteger)numberOfLinesOfText;


@end
