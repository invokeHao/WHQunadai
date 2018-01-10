//
//  WHAnnouncementLabel.m
//  qunadai
//
//  Created by wang on 2017/11/27.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "WHAnnouncementLabel.h"

#define kDynamicLabelAnimationKey @"DynamicLabelAnimation"

@interface WHAnnouncementLabel()
@property (nonatomic ,strong)UILabel *animationLabel;

@property (nonatomic ,strong)UILabel * lastLabel;
@end

@implementation WHAnnouncementLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.speed = 0.3;
        [self initAnimationLabel];
        [self addNotification];
    }
    return self;
}
- (void)initAnimationLabel{
    _animationLabel = [[UILabel alloc]init];
    _animationLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_animationLabel];
    
    _lastLabel = [[UILabel alloc]init];
    _lastLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_lastLabel];
    
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.mask = maskLayer;
}
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
#pragma mark -
#pragma mark - set mothods
- (void)setText:(NSString *)text{
    self.animationLabel.text = text;
    self.lastLabel.text = text;
    [self.animationLabel sizeToFit];
    [self.lastLabel sizeToFit];
}
- (void)setTextColor:(UIColor *)textColor{
    self.animationLabel.textColor = textColor;
    self.lastLabel.textColor = textColor;
}
- (void)setFont:(UIFont *)font{
    self.animationLabel.font = font;
    self.lastLabel.font = font;
    [self.lastLabel sizeToFit];
    [self.animationLabel sizeToFit];
    CGRect frame = self.frame;
    if (frame.size.height < font.lineHeight) {
        frame.size.height = font.lineHeight;
        self.frame = frame;
    }
}
#pragma mark -
#pragma mark - start or stop animation
- (void)startAnimation{
    if ([self.animationLabel.layer animationForKey:kDynamicLabelAnimationKey] || self.animationLabel.frame.size.width <= self.frame.size.width) {
        return;
    }
    [self.lastLabel setFrame:CGRectMake(self.lastLabel.width+100, 0, self.lastLabel.width, self.lastLabel.height)];

    CGFloat lenth = 2*self.animationLabel.frame.size.width + self.frame.size.width+100;
    CAKeyframeAnimation* keyFrame = [CAKeyframeAnimation animation];
    keyFrame.keyPath = @"transform.translation.x";
    keyFrame.values = @[@(0), @(-2*self.animationLabel.frame.size.width)];
    keyFrame.repeatCount = NSIntegerMax;
    keyFrame.duration = lenth * self.speed / 10;
    keyFrame.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.animationLabel.layer addAnimation:keyFrame forKey:kDynamicLabelAnimationKey];
    
    CAKeyframeAnimation * lastFrame = [CAKeyframeAnimation animation];
    lastFrame.keyPath = @"transform.translation.x";
    lastFrame.values = @[@(0),@(-2*self.lastLabel.width-100)];
    lastFrame.repeatCount = NSIntegerMax;
    lastFrame.duration = lenth * self.speed / 10;
    lastFrame.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.lastLabel.layer addAnimation:lastFrame forKey:kDynamicLabelAnimationKey];
}
- (void)stopAnimation{
    if ([self.animationLabel.layer animationForKey:kDynamicLabelAnimationKey]) {
        [self.animationLabel.layer removeAnimationForKey:kDynamicLabelAnimationKey];
    }
    if ([self.lastLabel.layer animationForKey:kDynamicLabelAnimationKey]) {
        [self.lastLabel.layer removeAnimationForKey:kDynamicLabelAnimationKey];
    }

}
#pragma mark -
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
