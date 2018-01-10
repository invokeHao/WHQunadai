//
//  rankView.m
//  Yizhenapp
//
//  Created by augbase on 16/5/6.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "rankView.h"
#import "NSTimer+WHTool.h"
#define angle2Arc(angle) (angle * M_PI /180)
//设置文字缩放比例
#define FontScale MIN(self.bounds.size.height, self.bounds.size.width)/100.f

@interface rankView ()
/**
 *  弧度
 */
@property (nonatomic,assign)CGFloat angle;

/**
 *  圆心
 */
@property (nonatomic,assign)CGPoint circleCenter;

/**
 *  屏帧定时器
 */
@property (nonatomic,strong)CADisplayLink *link;


@property (nonatomic,strong)NSTimer * timer;


/**
 *  定时器变量
 */
@property (nonatomic,assign)CGFloat value;

/**
 *  中间变量，用于动画时候数字的变化
 */
@property (nonatomic,assign)CGFloat desValue ;


@end

@implementation rankView
{
    int _num;
}

-(instancetype)init{
    if (self = [super init]) {
        [self defaultColor];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultColor];
    }
    return self;
}

-(instancetype)initWithLineColor:(UIColor*)lineColor
                       loopColor:(UIColor*)loopColor andNum:(int)num{
    if (self = [super init]) {
        self.lineColor = lineColor;
        self.loopColor = loopColor;
        _ValueNum = num;
        _num = 0;
    }
    return self;
}

-(void)defaultColor{
    _lineColor = [UIColor orangeColor];
    _loopColor = [UIColor greenColor];
}


- (void)drawRect:(CGRect)rect {
    
    _circleCenter = CGPointMake(rect.size.width*0.5 , rect.size.height*0.5 );
    
    CGFloat radius = MIN(rect.size.height, rect.size.width) * 0.5;
    
    //最外面的圆
    UIBezierPath  * arc1 = [UIBezierPath bezierPathWithArcCenter:_circleCenter radius:radius-3 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [arc1 setLineWidth:2.64];
    [self.lineColor set];
    [arc1 stroke];
    
    //画内圆
    UIBezierPath* arc2 = [UIBezierPath bezierPathWithArcCenter:_circleCenter
                                                        radius:radius-15
                                                    startAngle:M_PI_4+M_PI_2
                                                      endAngle:2*M_PI+M_PI_2-M_PI_4
                                                     clockwise:YES];
    [arc2 setLineWidth:5.28];
    [self.lineColor set];
    [arc2 stroke];
    
    //画弧线
    UIBezierPath* path = [UIBezierPath
                          bezierPathWithArcCenter:_circleCenter
                          radius:radius-15
                          startAngle:M_PI_4+M_PI_2
                          endAngle:angle2Arc(self.angle)+M_PI-M_PI_4
                          clockwise:YES];
    [self.loopColor set];
    path.lineWidth = 5.28;
    [path stroke];
    
    [self drawText];
}

/**
 *  绘制文字
 */
-(void)drawText{
    //绘制标题
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:@"预估额度"];
    NSRange titleRange = NSMakeRange(0, title.string.length);
    [title addAttribute:NSFontAttributeName
                  value:QNDFont(14.0)
                  range:titleRange];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:QNDRGBColor(195, 195, 195)
                  range:titleRange];
    
    CGRect titleRect = [title boundingRectWithSize:self.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil];
    
    CGFloat titleX = _circleCenter.x  - titleRect.size.width * 0.5;
    CGFloat titleY = _circleCenter.y -  titleRect.size.height-10 ;
    
    [title drawAtPoint:CGPointMake(titleX, titleY)];
//    //UI搭建
    self.valueLabel.center=CGPointMake(_circleCenter.x, _circleCenter.y + titleRect.size.height-10);
    self.valueLabel.bounds=CGRectMake(0, 0, 100, 26);
    self.valueLabel.text = FORMAT(@"%d",_num);
    [self addSubview:_valueLabel];
}


-(void)setPercent:(CGFloat)precent{
    if (precent>100) {
        precent = 100;
    }
    _percent = precent;
    if (self.animatable) {
        self.link.paused = NO;
    }else{
        _angle = _percent /100 * 270;
        _desValue = _percent;
        [self setNeedsDisplay];
    }
}
/**
 *  屏帧动画
 */
-(void)animateprecent{
    if (self.value < self.percent) {
        self.value ++;
        _num += _ValueNum/_percent;
        _desValue = _value;
        _angle = self.value /100 * 270;
        [self setNeedsDisplay];
    }
    else{
        self.link.paused = YES;
        self.value = 0;
        self.valueLabel.text = FORMAT(@"%d",_ValueNum);
    }
}

#pragma makr - 懒加载定时器
-(CADisplayLink *)link{
    if (_link == nil && self.animatable == YES) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateprecent)];
        _link.frameInterval = 1;
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}


#pragma mark - 设置默认颜色
-(UIColor *)titleColor{
    if (_titleColor == nil) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}

-(UIColor*)percentColor{
    if (_percentColor == nil) {
        _percentColor = [UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:1];
    }
    return _percentColor;
}

#pragma mark - 懒加载title
-(NSString *)title{
    if (_title == nil) {
        _title = @"";
    }
    return _title;
}

#pragma mark - 懒加载单位
-(NSString *)percentUnit{
    if (_percentUnit == nil) {
        _percentUnit = @"";
    }
    return _percentUnit;
}

#pragma nark-懒记载所差分数
-(NSString*)lessPoint
{
    if (_lessPoint ==nil) {
        _lessPoint= @"";
    }
    return _lessPoint;
}

-(UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel=[[UILabel alloc]init];
        if (_ValueNum<1) {
            _valueLabel.text=@"完善信息获取额度";
            _valueLabel.font=QNDFont(12.0);
            _valueLabel.textColor=ThemeColor;

        }else{
            _valueLabel.text = FORMAT(@"%d",_ValueNum);
            _valueLabel.font=QNDFont(25.0);
            _valueLabel.textColor=QNDRGBColor(236, 78, 39);
        }

        _valueLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _valueLabel;
}

-(void)dealloc{
    [self.link invalidate];
    self.link = nil;
    [self.timer invalidate];
    self.timer = nil;
}

@end
