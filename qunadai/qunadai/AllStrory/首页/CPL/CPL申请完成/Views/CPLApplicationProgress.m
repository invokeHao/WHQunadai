//
//  CPLApplicationProgress.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//
#define circleRadiu 12

#define UnfinishColor QNDRGBColor(214, 214, 214)
#define KCenterMargin (ViewWidth - 94)/3

#import "CPLApplicationProgress.h"

@interface CPLApplicationProgress ()
{
    CGPoint  submitCenter;//提交材料
    CGPoint  inViewCenter;//正在审核
    CGPoint  rejectCenter;//拒绝
    CGPoint  successCenter;//审核通过
}

@end


@implementation CPLApplicationProgress

-(instancetype)initWithFinishStep:(CPLApplicatinType)type andFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.backgroundColor = QNDRGBColor(242, 242, 242);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //第一个圆
    submitCenter = CGPointMake(35+circleRadiu,20+circleRadiu);
    
    UIBezierPath* arc1 = [UIBezierPath bezierPathWithArcCenter:submitCenter
                                                        radius:circleRadiu
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    [ThemeColor setFill];
    [arc1 fill];
    
    //第二个圆
    inViewCenter = CGPointMake(submitCenter.x + KCenterMargin, 20+circleRadiu);
    
    UIBezierPath * arc2 = [UIBezierPath bezierPathWithArcCenter:inViewCenter radius:circleRadiu startAngle:0 endAngle:2*M_PI clockwise:YES];
    if (_type == ApplicationSubmit) {
        [UnfinishColor setFill];
    }else{
        [ThemeColor setFill];
    }
    [arc2 fill];
    
    //第三个圆
    rejectCenter = CGPointMake(inViewCenter.x + KCenterMargin, 20+circleRadiu);
    UIBezierPath * arc3 = [UIBezierPath bezierPathWithArcCenter:rejectCenter radius:circleRadiu startAngle:0 endAngle:2*M_PI clockwise:YES];
    if (_type == ApplicationReject || _type == ApplicationSuccess) {
        [ThemeColor setFill];
    }else{
        [UnfinishColor setFill];
    }
    [arc3 fill];
    
    //第四个圆
    successCenter = CGPointMake(rejectCenter.x + KCenterMargin, 20+circleRadiu);
    UIBezierPath * arc4 = [UIBezierPath bezierPathWithArcCenter:successCenter radius:circleRadiu startAngle:0 endAngle:2*M_PI clockwise:YES];
    [UnfinishColor setFill];
    [arc4 fill];
    
    
    //绘制文字
    [self drawTexts];
    
    //绘制连接线条
    UIBezierPath * line1 = [UIBezierPath bezierPath];
    [line1 moveToPoint:CGPointMake(submitCenter.x+ 15 +circleRadiu, submitCenter.y )];
    [line1 addLineToPoint:CGPointMake(inViewCenter.x - 15 - circleRadiu, inViewCenter.y)];
    line1.lineWidth = 2;
    line1.lineCapStyle = kCGLineCapRound;
    [QNDRGBColor(214, 214, 214) setStroke];
    [line1 stroke];
    
    UIBezierPath * line2 = [UIBezierPath bezierPath];
    [line2 moveToPoint:CGPointMake(inViewCenter.x + 15 + circleRadiu, inViewCenter.y)];
    [line2 addLineToPoint:CGPointMake(rejectCenter.x - 15 - circleRadiu, rejectCenter.y)];
    line2.lineWidth = 2;
    line2.lineCapStyle = kCGLineCapRound;
    [QNDRGBColor(214, 214, 214) setStroke];
    [line2 stroke];
    
    UIBezierPath * line3 = [UIBezierPath bezierPath];
    [line3 moveToPoint:CGPointMake(rejectCenter.x + 15 + circleRadiu, rejectCenter.y)];
    [line3 addLineToPoint:CGPointMake(successCenter.x - 15 - circleRadiu, successCenter.y)];
    line3.lineWidth = 2;
    line3.lineCapStyle = kCGLineCapRound;
    [QNDRGBColor(214, 214, 214) setStroke];
    [line3 stroke];

    
}

-(void)drawTexts{
    
    NSString * str1 = @"1";
    NSString * str2 = @"2";
    NSString * str3 = @"3";
    NSString * str4 = @"4";
    
    //圆中的编号
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:str1];
    NSRange titleRange = NSMakeRange(0, title.string.length);
    [title addAttribute:NSFontAttributeName
                  value:QNDFont(14)
                  range:titleRange];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[UIColor whiteColor]
                  range:titleRange];
    
    CGRect titleRect = [title boundingRectWithSize:self.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil];
    
    CGFloat titleX = submitCenter.x  - titleRect.size.width * 0.5;
    CGFloat titleY = submitCenter.y -  titleRect.size.height/2 ;
    
    [title drawAtPoint:CGPointMake(titleX, titleY)];
    
    
    NSMutableAttributedString* title2 = [[NSMutableAttributedString alloc] initWithString:str2];
    NSRange titleRange2 = NSMakeRange(0, title2.string.length);
    [title2 addAttribute:NSFontAttributeName
                   value:QNDFont(14)
                   range:titleRange2];
    
    [title2 addAttribute:NSForegroundColorAttributeName
                   value:[UIColor whiteColor]
                   range:titleRange2];
    
    CGRect titleRect2 = [title2 boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat titleX2 = inViewCenter.x  - titleRect2.size.width * 0.5;
    CGFloat titleY2 = inViewCenter.y -  titleRect2.size.height/2 ;
    
    [title2 drawAtPoint:CGPointMake(titleX2, titleY2)];
    
    
    NSMutableAttributedString * title3 = [[NSMutableAttributedString alloc]initWithString:str3];
    NSRange titleRange3 = NSMakeRange(0, title3.string.length);
    [title3 addAttribute:NSFontAttributeName value:QNDFont(14.0) range:titleRange3];
    [title3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:titleRange3];
    CGRect titleRect3 = [title3 boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat titleX3 = rejectCenter.x - titleRect3.size.width*0.5;
    CGFloat titleY3 = rejectCenter.y - titleRect3.size.height/2;
    [title3 drawAtPoint:CGPointMake(titleX3, titleY3)];
    
    NSMutableAttributedString * title4 = [[NSMutableAttributedString alloc]initWithString:str4];
    NSRange titleRange4 = NSMakeRange(0, title4.string.length);
    [title4 addAttribute:NSFontAttributeName value:QNDFont(14.0) range:titleRange4];
    [title4 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:titleRange4];
    CGRect titleRect4 = [title4 boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat titleX4 = successCenter.x - titleRect4.size.width*0.5;
    CGFloat titleY4 = successCenter.y - titleRect4.size.height/2;
    [title4 drawAtPoint:CGPointMake(titleX4, titleY4)];

    
    //////圆下面的文字
    NSMutableAttributedString* realInfo = [[NSMutableAttributedString alloc] initWithString:@"提交材料"];
    NSRange realRange = NSMakeRange(0, realInfo.string.length);
    [realInfo addAttribute:NSFontAttributeName
                     value:QNDFont(12)
                     range:realRange];
    
    [realInfo addAttribute:NSForegroundColorAttributeName
                     value:QNDUnSelectedText195Color
                     range:realRange];
    
    CGRect realRect = [realInfo boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat realX = submitCenter.x  - realRect.size.width * 0.5;
    CGFloat realY = submitCenter.y + realRect.size.height/2 + 8;
    
    [realInfo drawAtPoint:CGPointMake(realX, realY)];
    
    
    NSMutableAttributedString* bankInfo = [[NSMutableAttributedString alloc] initWithString:@"正在审核"];
    NSRange bankRange = NSMakeRange(0, bankInfo.string.length);
    [bankInfo addAttribute:NSFontAttributeName
                     value:QNDFont(12)
                     range:bankRange];
    
    [bankInfo addAttribute:NSForegroundColorAttributeName
                     value:QNDUnSelectedText195Color
                     range:bankRange];
    
    CGRect bankRect = [realInfo boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat bankX = inViewCenter.x  - bankRect.size.width * 0.5;
    CGFloat bankY = inViewCenter.y +  bankRect.size.height/2 + 8;
    
    [bankInfo drawAtPoint:CGPointMake(bankX, bankY)];
    
    NSString * str = @"审核结果";
    if (_type == ApplicationReject) {
        str = @"审核拒绝";
    }
    if (_type == ApplicationSuccess) {
        str = @"审核通过";
    }
    NSMutableAttributedString* proInfo = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange proRange = NSMakeRange(0, proInfo.string.length);
    [proInfo addAttribute:NSFontAttributeName
                    value:QNDFont(12)
                    range:proRange];
    
    [proInfo addAttribute:NSForegroundColorAttributeName
                    value:QNDUnSelectedText195Color
                    range:proRange];
    
    CGRect proRect = [proInfo boundingRectWithSize:self.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil];
    
    CGFloat proX = rejectCenter.x  - proRect.size.width * 0.5;
    CGFloat proY = rejectCenter.y +  proRect.size.height/2 + 8;
    
    [proInfo drawAtPoint:CGPointMake(proX, proY)];
    
    
    NSMutableAttributedString* sucessInfo = [[NSMutableAttributedString alloc] initWithString:@"放款"];
    NSRange sucessRange = NSMakeRange(0, sucessInfo.string.length);
    [sucessInfo addAttribute:NSFontAttributeName
                    value:QNDFont(12)
                    range:sucessRange];
    
    [sucessInfo addAttribute:NSForegroundColorAttributeName
                    value:QNDUnSelectedText195Color
                    range:sucessRange];
    
    CGRect sucessRect = [sucessInfo boundingRectWithSize:self.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil];
    
    CGFloat sucX = successCenter.x  - sucessRect.size.width * 0.5;
    CGFloat sucY = successCenter.y +  sucessRect.size.height/2 + 8;
    
    [sucessInfo drawAtPoint:CGPointMake(sucX, sucY)];
}

-(void)setType:(CPLApplicatinType)type{
    _type = type;
    [self setNeedsDisplay];
}



@end
