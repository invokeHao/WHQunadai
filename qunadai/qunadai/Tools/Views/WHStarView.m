//
//  WHStarView.m
//  qunadai
//
//  Created by wang on 2017/9/28.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "WHStarView.h"

@interface WHStarView ()

@property (nonatomic, strong) UIImage *prayStarImg;
@property (nonatomic, strong) UIImage *lightStarImg;

@end
@implementation WHStarView
- (UIImage *)prayStarImg {
    if (!_prayStarImg) {
        _prayStarImg = [UIImage imageNamed:@"pray_star"];
    }
    return _prayStarImg;
}

- (UIImage *)lightStarImg {
    if (!_lightStarImg) {
        _lightStarImg = [UIImage imageNamed:@"light_star"];
    }
    return _lightStarImg;
}

- (void)setLightPercent:(CGFloat)lightPercent {
    _lightPercent = lightPercent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_lightPercent == 1) {
        [self.lightStarImg drawInRect:rect];
        return;
    }
    if (_lightPercent == 0) {
        [self.prayStarImg drawInRect:rect];
        return;
    }
    
    CGFloat lightWidth = rect.size.width * _lightPercent;
    CGFloat prayWidth = rect.size.width - lightWidth;
    
    UIImage *leftImg = [self croppedImgWithImg:self.lightStarImg percent:_lightPercent fromLeft:YES];
    UIImage *rightImg = [self croppedImgWithImg:self.prayStarImg percent:(1 - _lightPercent) fromLeft:NO];
    
    [leftImg drawInRect:CGRectMake(0, 0, lightWidth, rect.size.height)];
    [rightImg drawInRect:CGRectMake(lightWidth, 0, prayWidth, rect.size.height)];
}

- (UIImage *)croppedImgWithImg:(UIImage *)img percent:(CGFloat)percent fromLeft:(BOOL)isfromLeft {
    CGSize imgSize = img.size;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgSize.width * percent, imgSize.height), NO, 0);
    if (isfromLeft) {
        [img drawAtPoint:CGPointMake(0, 0)];
    } else {
        [img drawAtPoint:CGPointMake(imgSize.width * percent - imgSize.width, 0)];
    }
    UIImage *croppedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImg;
}

@end

#import "WHStarView.h"

@interface WHStarsView ()

@property (nonatomic, strong) NSMutableArray *starViewArray;

@end

@implementation WHStarsView

- (instancetype)initWithStarSize:(CGSize)starSize margin:(CGFloat)margin numberOfStars:(NSInteger)number {
    if (self = [super init]) {
        _allowSelect = YES;
        _allowDecimal = YES;
        _starViewArray = [[NSMutableArray alloc] init];
        self.frame = CGRectMake(0, 0, starSize.width * number + margin * (number - 1), starSize.height);
        for (int i = 0; i < number; i ++) {
            WHStarView *starView = [[WHStarView alloc] initWithFrame:CGRectMake((starSize.width + margin) * i, 0, starSize.width, starSize.height)];
            starView.lightPercent = 1.0;
            starView.backgroundColor = [UIColor clearColor];
            [self addSubview:starView];
            [_starViewArray addObject:starView];
        }
    }
    return self;
}

- (void)setScore:(CGFloat)originalScore {
    _score = originalScore;
    if (originalScore > _starViewArray.count) {
        _score = _starViewArray.count;
    } else if (originalScore < 0) {
        _score = 0;
    }
    
    NSInteger wholeLightStarsCount = (NSInteger)_score;
    WHStarView *lastLightStarView = (wholeLightStarsCount == _starViewArray.count ? nil : _starViewArray[wholeLightStarsCount]);
    for (int i = 0; i < _starViewArray.count; i ++) {
        WHStarView *starView = _starViewArray[i];
        if (i < wholeLightStarsCount) {
            starView.lightPercent = 1.0;
        } else if (i > wholeLightStarsCount ) {
            starView.lightPercent = 0.0;
        } else {
            lastLightStarView.lightPercent = _score - wholeLightStarsCount;
        }
    }
    if (self.touchedActionBlock) {
        self.touchedActionBlock(_score);
    }
    
}

#pragma - HandleTouch

- (void)handleTouches:(NSSet *)touchs {
    if (!_allowSelect) {
        return;
    }
    
    UITouch *touch = [touchs anyObject];
    CGPoint locatedPoint = [touch locationInView:self];
    WHStarView *starView = nil;
    for (WHStarView * star in _starViewArray) {
        if (star.frame.origin.x <= locatedPoint.x && star.frame.origin.x + star.frame.size.width >= locatedPoint.x) {
            starView = star;
            break;
        }
    }
    if (!starView) {
        return;
    }
    _score = 0.0;
    NSInteger lastLightStarViewIndex = [_starViewArray indexOfObject:starView];
    for (int i = 0; i < _starViewArray.count; i ++ ) {
        WHStarView *star = _starViewArray[i];
        if (i < lastLightStarViewIndex) {
            star.lightPercent = 1.0;
            _score += 1.0;
        } else if (i > lastLightStarViewIndex) {
            star.lightPercent = 0.0;
        } else {
            if (_allowDecimal) {
                CGFloat lightPercent = (locatedPoint.x - star.frame.origin.x) / star.frame.size.width;
                _score += lightPercent;
                star.lightPercent = lightPercent;
            } else {
                _score += 1.0;
                star.lightPercent = 1.0;
            }
        }
        
    }
    _score = [NSString stringWithFormat:@"%.2f", _score].floatValue;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_allowDragSelect) {
        [self handleTouches:touches];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchedActionBlock) {
        self.touchedActionBlock(_score);
    }
}

@end
