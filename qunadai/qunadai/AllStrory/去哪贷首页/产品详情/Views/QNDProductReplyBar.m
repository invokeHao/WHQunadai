//
//  QNDProductReplyBar.m
//  qunadai
//
//  Created by wang on 2017/9/29.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDProductReplyBar.h"
@interface QNDProductReplyBar ()<UITextViewDelegate,WHTextViewDelegate>

@property CGFloat previousTextViewHeight;

@end


@implementation QNDProductReplyBar
{
    UIButton * _commentBtn;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutViews];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"self.inputText.contentSize"];
}

-(void)layoutViews{
    [self setupViews];
    //KVO
    [self addObserver:self forKeyPath:@"self.inputText.contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
}

-(void)setupViews{
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    [self.inputText setFrame:CGRectMake(12, 10, ViewWidth-68, 30)];
    
    self.previousTextViewHeight = 30;
    
    if (!_pleaseholderLabel) {
        _pleaseholderLabel = [[UILabel alloc]init];
        _pleaseholderLabel.font = QNDFont(12.0);
        _pleaseholderLabel.text = @"我也说两句...";
        _pleaseholderLabel.textColor = defaultPlaceHolderColor;
        [self.inputText addSubview:_pleaseholderLabel];
        
        [_pleaseholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_inputText.mas_right).with.offset(4);
            make.top.equalTo(@12);
            make.height.equalTo(@13);
        }];
    }
}

-(void)pressToLike:(UIButton*)button{
    
}

-(void)pressToSeeTheComment:(UIButton*)button{
    [self.delegate PostTheReplyWithContent:_inputText.text];
    _inputText.text = @"";
}


#pragma mark-UITextView delegate

-(void)textViewDidChange:(UITextView *)textView{
    _pleaseholderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    _pleaseholderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

#pragma mark - kvo回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"self.inputText.contentSize"]) {
        [self layoutAndAnimateTextView:self.inputText];
    }
}

#pragma mark -- 计算textViewContentSize改变

- (CGFloat)getTextViewContentH:(WHTextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (CGFloat)fontWidth
{
    return 30.f; //16号字体
}

- (CGFloat)maxLines
{
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat line = 5;
    if (h == 480) {
        line = 3;
    }else if (h == 568){
        line = 3.5;
    }else if (h == 667){
        line = 4;
    }else if (h == 736){
        line = 4.5;
    }
    return line;
}


//输入框动态增高
- (void)layoutAndAnimateTextView:(WHTextView *)textView
{
    CGFloat maxHeight = [self fontWidth] * [self maxLines];
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    
    //输入状态
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                             CGRect inputViewFrame = self.frame;
                             self.frame = CGRectMake(0.0f,inputViewFrame.origin.y-changeInHeight,
                                                     inputViewFrame.size.width,
                                                     (inputViewFrame.size.height + changeInHeight));
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        self.previousTextViewHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.inputText.frame;
    
    NSUInteger numLines = MAX([self.inputText numberOfLinesOfText],
                              [[self.inputText.text componentsSeparatedByString:@"\n"] count] + 1);
    
    
    self.inputText.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    
    self.inputText.contentInset = UIEdgeInsetsMake((numLines >=6 ? 4.0f : 0.0f), 0.0f, (numLines >=6 ? 4.0f : 0.0f), 0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    //self.messageInputTextView.scrollEnabled = YES;
    
    if (numLines >=6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.inputText.contentSize.height-self.inputText.bounds.size.height);
        [self.inputText setContentOffset:bottomOffset animated:YES];
        [self.inputText scrollRangeToVisible:NSMakeRange(self.inputText.text.length-2, 1)];
    }
}


-(UITextView *)inputText{
    if (!_inputText) {
        _inputText = [[WHTextView alloc]init];
        _inputText.font = QNDFont(14.0);
        _inputText.textColor = QNDRGBColor(109, 109, 109);
        _inputText.delegate = self;
        _inputText.backgroundColor = QNDRGBColor(242, 242, 242);
        _inputText.layer.cornerRadius = 4;
        _inputText.clipsToBounds = YES;
        _inputText.tintColor = ThemeColor;
        [self addSubview:_inputText];
    }
    return _inputText;
}

-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setContentMode:UIViewContentModeCenter];
        [_commentBtn setImage:[UIImage imageNamed:@"icon_send"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(pressToSeeTheComment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentBtn];
    }
    return _commentBtn;
}

@end
