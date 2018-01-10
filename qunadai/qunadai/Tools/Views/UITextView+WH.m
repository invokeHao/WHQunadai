//
//  UITextView+WH.m
//  qunadai
//
//  Created by wang on 2017/7/18.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "UITextView+WH.h"
#import <objc/runtime.h>

static const void *WHPlaceholderViewKey = &WHPlaceholderViewKey;
static const void *WHPlaceholderColorKey = &WHPlaceholderColorKey;
static const void *WHTextViewMaxHeightKey = &WHTextViewMaxHeightKey;
static const void *WHTextViewMinHeightKey = &WHTextViewMinHeightKey;
static const void *WHTextViewDidChangedBlockKey = &WHTextViewDidChangedBlockKey;
static const void *WHTextViewLastHeightKey = &WHTextViewLastHeightKey;

@implementation UITextView (WH)

+ (void)load {
    // 交换dealoc
    Method dealoc = class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc"));
    Method myDealoc = class_getInstanceMethod(self.class, @selector(myDealoc));
    method_exchangeImplementations(dealoc, myDealoc);
}

- (void)myDealoc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UITextView *InputTextView = objc_getAssociatedObject(self, WHPlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (InputTextView) {
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        for (NSString *property in propertys) {
            @try {
                [self removeObserver:self forKeyPath:property];
            } @catch (NSException *exception) {}
        }
    }
    [self myDealoc];
}

#pragma mark- setter&&getter

-(UITextView*)placeholderView{
    //为了保证占位文字和textview的位置一致,也设置为TextView
    UITextView * placeholderView = objc_getAssociatedObject(self, WHPlaceholderViewKey);
    if (!placeholderView) {
        placeholderView = [[UITextView alloc]init];
        //将对象和值关联起来
        objc_setAssociatedObject(self, WHPlaceholderViewKey, placeholderView, OBJC_ASSOCIATION_COPY_NONATOMIC);
        placeholderView = placeholderView;
        //设置一些基础属性(可根据具体情况具体设置)
        
        self.scrollEnabled = placeholderView.scrollEnabled = placeholderView.showsHorizontalScrollIndicator = placeholderView.showsVerticalScrollIndicator = placeholderView.userInteractionEnabled = NO;
        placeholderView.textColor = defaultPlaceHolderColor;
        placeholderView.backgroundColor = [UIColor clearColor];
        [self refreshPlaceholderView];
        [self addSubview:placeholderView];
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange) name:UITextViewTextDidChangeNotification object:self];
        
        // 这些属性改变时，都要作出一定的改变，尽管已经监听了TextDidChange的通知，也要监听text属性，因为通知监听不到setText：
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        
        // 监听属性
        for (NSString *property in propertys) {
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return placeholderView;
}

-(void)setPlaceholder:(NSString *)placeholder{
    [self placeholderView].text = placeholder;
}

-(NSString*)placeholder{
    if ([self placeholderExist]) {
        return [self placeholderView].text;
    }
    return nil;
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    if (![self placeholderExist]) {
        WHLog(@"先去设置placeholder的值");
    }else{
        self.placeholderView.textColor = placeholderColor;
        objc_setAssociatedObject(self, WHPlaceholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(UIColor*)placeholderColor{
    return objc_getAssociatedObject(self, WHPlaceholderColorKey);
}

-(void)setMaxHeight:(CGFloat)maxHeight{
    CGFloat max = maxHeight;
    if (max<self.height) {
        max = self.height;
    }
    objc_setAssociatedObject(self, WHTextViewMaxHeightKey, [NSString stringWithFormat:@"%f",max], OBJC_ASSOCIATION_ASSIGN);
}

-(CGFloat)maxHeight{
    return [objc_getAssociatedObject(self, WHTextViewMaxHeightKey) floatValue];
}

-(void)setMinHeight:(CGFloat)minHeight{
    objc_setAssociatedObject(self, WHTextViewMinHeightKey, [NSString stringWithFormat:@"%f",minHeight], OBJC_ASSOCIATION_ASSIGN);
}

-(CGFloat)minHeight{
    return  [objc_getAssociatedObject(self, WHTextViewMinHeightKey) floatValue];
}

-(void)setLastHeight:(CGFloat)lastHeight{
    objc_setAssociatedObject(self, WHTextViewLastHeightKey, [NSString stringWithFormat:@"%f",lastHeight], OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)lastHeight{
    return [objc_getAssociatedObject(self, WHTextViewLastHeightKey) floatValue];
}

-(void)setHeightChangedBlock:(textViewHeightWillChangedBlock)heightChangedBlock{
    objc_setAssociatedObject(self, WHTextViewDidChangedBlockKey, heightChangedBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(textViewHeightWillChangedBlock)heightChangedBlock{
    void(^textViewHeightDidChanged)(CGFloat currentHeight) = objc_getAssociatedObject(self, WHTextViewDidChangedBlockKey);
    return textViewHeightDidChanged;
}

#pragma mark - KVO监听属性改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self refreshPlaceholderView];
    if ([keyPath isEqualToString:@"text"]) [self textViewTextChange];
}


- (void)refreshPlaceholderView {
    
    UITextView *placeholderView = objc_getAssociatedObject(self, WHPlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (placeholderView) {
//        self.placeholderView.frame = self.bounds;
//        self.placeholderView.font = self.font;
//        self.placeholderView.textAlignment = self.textAlignment;
//        self.placeholderView.textContainerInset = self.textContainerInset;
    }
}

- (void)textViewTextChange {
    UITextView *placeholderView = objc_getAssociatedObject(self, WHPlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (placeholderView) {
//        self.placeholderView.hidden = (self.text.length > 0 && self.text);
    }
    
    if (self.maxHeight >= self.bounds.size.height) {
        
        // 计算高度
        NSInteger currentHeight = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
        
        // 如果高度有变化，调用block
        if (currentHeight != self.lastHeight) {
            // 是否可以滚动
            self.scrollEnabled = currentHeight >= self.maxHeight;
            CGFloat currentTextViewHeight = currentHeight >= self.maxHeight ? self.maxHeight : currentHeight;
            // 改变textView的高度
            if (currentTextViewHeight >= self.minHeight) {
                CGRect frame = self.frame;
                frame.size.height = currentTextViewHeight;
                self.frame = frame;
                // 调用block
                if (self.heightChangedBlock) self.heightChangedBlock(currentTextViewHeight);
                // 记录当前高度
                self.lastHeight = currentTextViewHeight;
            }
        }
    }
    
    if (!self.isFirstResponder) [self becomeFirstResponder];
}

- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight {
    [self autoHeightWithMaxHeight:maxHeight textViewHeightDidChanged:nil];
}

- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(void(^)(CGFloat currentTextViewHeight))textViewHeightDidChanged {
    [self placeholderView];//先不使用这个功能
    self.maxHeight = maxHeight;
    if (textViewHeightDidChanged) self.heightChangedBlock = textViewHeightDidChanged;
}

// 判断是否有placeholder值，这步很重要
- (BOOL)placeholderExist {
    
    // 获取对应属性的值
    UITextView *placeholderView = objc_getAssociatedObject(self, WHPlaceholderViewKey);
    
    // 如果有placeholder值
    if (placeholderView) return YES;
    
    return NO;
}



@end
