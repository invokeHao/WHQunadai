//
//  InfoProgressiView.m
//  qunadai
//
//  Created by wang on 17/4/10.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "InfoProgressiView.h"

@interface InfoProgressiView()

{
    CGPoint  infoCenter;
    CGPoint  bankCenter;
    NSString * cicleTitle;
}

@end

@implementation InfoProgressiView


-(instancetype)initWithFinishColor:(UIColor *)finish andFrame:(CGRect)frame andTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        _finishColor = finish;
        cicleTitle = title;
        self.backgroundColor =grayBackgroundLightColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    infoCenter = CGPointMake(ViewWidth/3-10, 30);
    
    UIBezierPath* arc1 = [UIBezierPath bezierPathWithArcCenter:infoCenter
                                                        radius:10
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    [ThemeColor setFill];
    [arc1 fill];
    
    bankCenter = CGPointMake(ViewWidth/3*2+10, 30);
    
    UIBezierPath * arc2 = [UIBezierPath bezierPathWithArcCenter:bankCenter radius:10 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [_finishColor setFill];
    [arc2 fill];
    
    //绘制文字
    [self drawTexts];

    
    UIBezierPath * line = [UIBezierPath bezierPath];
    [line moveToPoint:CGPointMake(infoCenter.x+5 +10, infoCenter.y )];
    [line addLineToPoint:CGPointMake(bankCenter.x-5-10, bankCenter.y)];
    line.lineWidth = 2;
    line.lineCapStyle = kCGLineCapRound;
    [_finishColor setStroke];
    [line stroke];

}

-(void)drawTexts{
    
    NSString * str1 = @"1";
    NSString * str2 = @"2";
    //编号
    if ([cicleTitle isEqualToString:@"0"]) {
        //放对号
        UIImageView * rightView = [[UIImageView alloc]init];
        [rightView setImage:[UIImage imageNamed:@"xiaoduihao"]];
        [rightView setCenter:infoCenter];
        [rightView setBounds:CGRectMake(0, 0, 10, 7)];
        [self addSubview:rightView];
        str1 = @"";
        str2 = @"2";
    }
   else if ([cicleTitle isEqualToString:@"10"]) {
        //放对号
        UIImageView * rightView = [[UIImageView alloc]init];
        [rightView setImage:[UIImage imageNamed:@"xiaoduihao"]];
        [rightView setCenter:bankCenter];
        [rightView setBounds:CGRectMake(0, 0, 10, 7)];
        [self addSubview:rightView];
        str1 = @"1";
        str2 = @"";

    }
    
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:str1];
    NSRange titleRange = NSMakeRange(0, title.string.length);
    [title addAttribute:NSFontAttributeName
                  value:QNDFont(13)
                  range:titleRange];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[UIColor whiteColor]
                  range:titleRange];
    
    CGRect titleRect = [title boundingRectWithSize:self.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil];
    
    CGFloat titleX = infoCenter.x  - titleRect.size.width * 0.5;
    CGFloat titleY = infoCenter.y -  titleRect.size.height/2 ;
    
    [title drawAtPoint:CGPointMake(titleX, titleY)];

    NSMutableAttributedString* title2 = [[NSMutableAttributedString alloc] initWithString:str2];
    NSRange titleRange2 = NSMakeRange(0, title2.string.length);
    [title2 addAttribute:NSFontAttributeName
                   value:QNDFont(13)
                   range:titleRange2];
    
    [title2 addAttribute:NSForegroundColorAttributeName
                   value:[UIColor whiteColor]
                   range:titleRange2];
    
    CGRect titleRect2 = [title2 boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat titleX2 = bankCenter.x  - titleRect2.size.width * 0.5;
    CGFloat titleY2 = bankCenter.y -  titleRect2.size.height/2 ;
    
    [title2 drawAtPoint:CGPointMake(titleX2, titleY2)];

    NSMutableAttributedString* realInfo = [[NSMutableAttributedString alloc] initWithString:@"真实信息"];
    NSRange realRange = NSMakeRange(0, realInfo.string.length);
    [realInfo addAttribute:NSFontAttributeName
                   value:QNDFont(13)
                   range:realRange];
    
    [realInfo addAttribute:NSForegroundColorAttributeName
                   value:QNDAssistText153Color
                   range:realRange];
    
    CGRect realRect = [realInfo boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat realX = infoCenter.x  - realRect.size.width * 0.5;
    CGFloat realY = infoCenter.y + realRect.size.height/2 + 8;
    
    [realInfo drawAtPoint:CGPointMake(realX, realY)];
    
    
    NSMutableAttributedString* bankInfo = [[NSMutableAttributedString alloc] initWithString:@"身份认证"];
    NSRange bankRange = NSMakeRange(0, bankInfo.string.length);
    [bankInfo addAttribute:NSFontAttributeName
                     value:QNDFont(13)
                     range:bankRange];
    
    [bankInfo addAttribute:NSForegroundColorAttributeName
                     value:QNDAssistText153Color
                     range:bankRange];
    
    CGRect bankRect = [realInfo boundingRectWithSize:self.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    
    CGFloat bankX = bankCenter.x  - bankRect.size.width * 0.5;
    CGFloat bankY = bankCenter.y +  bankRect.size.height/2 + 8;
    
    [bankInfo drawAtPoint:CGPointMake(bankX, bankY)];
}


@end
