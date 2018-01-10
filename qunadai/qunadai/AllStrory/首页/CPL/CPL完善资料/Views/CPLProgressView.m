//
//  CPLProgressView.m
//  qunadai
//
//  Created by wang on 2017/11/2.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLProgressView.h"

#define circleRadiu 12

@interface CPLProgressView()
{
    CGPoint  basicCenter;//基本信息
    CGPoint  extraCenter;//补充信息
    CGPoint  productCenter;//匹配放款
}

@property (assign,nonatomic)CPLInfoType type;

@end


@implementation CPLProgressView

-(instancetype)initWithFinishStep:(CPLInfoType)type andFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //第一个圆
    basicCenter = CGPointMake(70, 35+circleRadiu);
    
    UIBezierPath* arc1 = [UIBezierPath bezierPathWithArcCenter:basicCenter
                                                        radius:circleRadiu
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    [ThemeColor setFill];
    [arc1 fill];
    
    //第二个圆
    extraCenter = CGPointMake(ViewWidth/2, 35+circleRadiu);
    
    UIBezierPath * arc2 = [UIBezierPath bezierPathWithArcCenter:extraCenter radius:circleRadiu startAngle:0 endAngle:2*M_PI clockwise:YES];
    if (_type == BasicInfoFinish) {
        [QNDRGBColor(214, 214, 214) setFill];
    }else{
        [ThemeColor setFill];
    }
    [arc2 fill];
    
    //第三个圆
    productCenter = CGPointMake(ViewWidth-70, 35+circleRadiu);
    UIBezierPath * arc3 = [UIBezierPath bezierPathWithArcCenter:productCenter radius:circleRadiu startAngle:0 endAngle:2*M_PI clockwise:YES];
    [QNDRGBColor(214, 214, 214) setFill];
    [arc3 fill];
    
    
    //绘制文字
    [self drawTexts];
    
    
    UIBezierPath * line1 = [UIBezierPath bezierPath];
    [line1 moveToPoint:CGPointMake(basicCenter.x+ 15 +circleRadiu, basicCenter.y )];
    [line1 addLineToPoint:CGPointMake(extraCenter.x - 15 - circleRadiu, extraCenter.y)];
    line1.lineWidth = 2;
    line1.lineCapStyle = kCGLineCapRound;
    [QNDRGBColor(214, 214, 214) setStroke];
    [line1 stroke];
    
    UIBezierPath * line2 = [UIBezierPath bezierPath];
    [line2 moveToPoint:CGPointMake(extraCenter.x + 15 + circleRadiu, extraCenter.y)];
    [line2 addLineToPoint:CGPointMake(productCenter.x - 15 - circleRadiu, productCenter.y)];
    line2.lineWidth = 2;
    line2.lineCapStyle = kCGLineCapRound;
    [QNDRGBColor(214, 214, 214) setStroke];
    [line2 stroke];
    
}

-(void)drawTexts{
    
    NSString * str1 = @"1";
    NSString * str2 = @"2";
    NSString * str3 = @"3";
    
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
    
    CGFloat titleX = basicCenter.x  - titleRect.size.width * 0.5;
    CGFloat titleY = basicCenter.y -  titleRect.size.height/2 ;
    
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
    
    CGFloat titleX2 = extraCenter.x  - titleRect2.size.width * 0.5;
    CGFloat titleY2 = extraCenter.y -  titleRect2.size.height/2 ;
    
    [title2 drawAtPoint:CGPointMake(titleX2, titleY2)];
    
    
    NSMutableAttributedString * title3 = [[NSMutableAttributedString alloc]initWithString:str3];
    NSRange titleRange3 = NSMakeRange(0, title3.string.length);
    [title3 addAttribute:NSFontAttributeName value:QNDFont(14.0) range:titleRange3];
    [title3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:titleRange3];
    CGRect titleRect3 = [title3 boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat titleX3 = productCenter.x - titleRect3.size.width*0.5;
    CGFloat titleY3 = productCenter.y - titleRect3.size.height/2;
    [title3 drawAtPoint:CGPointMake(titleX3, titleY3)];
    
    //////圆下面的文字
    NSMutableAttributedString* realInfo = [[NSMutableAttributedString alloc] initWithString:@"个人信息"];
    NSRange realRange = NSMakeRange(0, realInfo.string.length);
    [realInfo addAttribute:NSFontAttributeName
                     value:QNDFont(12)
                     range:realRange];
    
    [realInfo addAttribute:NSForegroundColorAttributeName
                     value:QNDAssistText153Color
                     range:realRange];
    
    CGRect realRect = [realInfo boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat realX = basicCenter.x  - realRect.size.width * 0.5;
    CGFloat realY = basicCenter.y + realRect.size.height/2 + 8;
    
    [realInfo drawAtPoint:CGPointMake(realX, realY)];
    
    
    NSMutableAttributedString* bankInfo = [[NSMutableAttributedString alloc] initWithString:@"补充信息"];
    NSRange bankRange = NSMakeRange(0, bankInfo.string.length);
    [bankInfo addAttribute:NSFontAttributeName
                     value:QNDFont(12)
                     range:bankRange];
    
    [bankInfo addAttribute:NSForegroundColorAttributeName
                     value:QNDAssistText153Color
                     range:bankRange];
    
    CGRect bankRect = [realInfo boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat bankX = extraCenter.x  - bankRect.size.width * 0.5;
    CGFloat bankY = extraCenter.y +  bankRect.size.height/2 + 8;
    
    [bankInfo drawAtPoint:CGPointMake(bankX, bankY)];
    
    
    NSMutableAttributedString* proInfo = [[NSMutableAttributedString alloc] initWithString:@"匹配放款"];
    NSRange proRange = NSMakeRange(0, proInfo.string.length);
    [proInfo addAttribute:NSFontAttributeName
                     value:QNDFont(12)
                     range:proRange];
    
    [proInfo addAttribute:NSForegroundColorAttributeName
                     value:QNDAssistText153Color
                     range:proRange];
    
    CGRect proRect = [proInfo boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat proX = productCenter.x  - proRect.size.width * 0.5;
    CGFloat proY = productCenter.y +  proRect.size.height/2 + 8;
    
    [proInfo drawAtPoint:CGPointMake(proX, proY)];

}

@end
