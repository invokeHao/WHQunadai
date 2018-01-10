//
//  productLoanModel.m
//  qunadai
//
//  Created by wang on 17/4/1.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "productLoanModel.h"
#import "NSString+extention.h"

@implementation productLoanModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.productId = [dic[@"productId"] integerValue];
        self.IDS = [dic[@"id"] integerValue];
        self.productCode = dic[@"productCode"];
        self.productName = dic[@"productName"];
        self.productUrl = dic[@"productUrl"];
        self.productLogoUrl = dic[@"productLogoUrl"];
        self.loanAmt = dic[@"loanAmt"];
        self.amtMax = [dic[@"amtMax"] integerValue];
        self.amtMin = [dic[@"amtMin"] integerValue];
        self.productRate = dic[@"productRate"];
        self.rateMin = [dic[@"rateMin"] floatValue];
        self.rateMax = [dic[@"rateMax"] floatValue];
        self.rateUnit = dic[@"rateUnit"];
        self.productTerm = dic[@"productTerm"];
        self.termMin = [dic[@"termMin"] integerValue];
        self.termMax = [dic[@"termMax"] integerValue];
        self.termUnit = dic[@"termUnit"];
        self.loanNum = [dic[@"loanNum"] integerValue];
        self.loanRate = [dic[@"loanRate"] integerValue];
        self.fastLoanTime = [dic[@"fastLoanTime"] integerValue];
        self.fastLoanTimeUnit = dic[@"fastLoanTimeUnit"];
        self.productConditions = dic[@"productConditions"];
        self.productAdvantage = dic[@"productAdvantage"];
        self.cooperationType = dic[@"cooperationType"];
        
        self.browsingTime = dic[@"browsingTime"];
        self.applied = [dic[@"applied"] boolValue];
    }
    return self;
}

-(CGFloat)textHeight{
    CGFloat Y = 25;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName : QNDFont(14.0),NSParagraphStyleAttributeName:paragraphStyle,};
    
    NSArray * arr = [self.productConditions componentsSeparatedByString:@"\\n"];
    for (NSString * str in arr) {
//        Y +=[str sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-30, MAXFLOAT)].height;
        
        CGSize size = [str boundingRectWithSize:CGSizeMake(ViewWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        Y +=size.height;
    }
    return Y;
}


-(NSString*)applyStr{
    NSString * applyStr;
    if (_productConditions) {
        applyStr = [self.productConditions stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }
    return applyStr;
}


-(NSString *)getTheLoanTimeStr{
    if (!self.fastLoanTime||!self.fastLoanTimeUnit) {
        return @"";
    }else{
        return  FORMAT(@"%ld%@放款",self.fastLoanTime,self.fastLoanTimeUnit);
    }
}

-(NSMutableAttributedString *)getTheLoanRateStr{
    if (self.rateMin<0||!self.rateUnit) {
        return nil;
    }else{
        NSString * rateStr = [NSString stringWithFormat:@"%.2f／%@",self.rateMin,self.rateUnit];
        //拼接%号
        NSMutableString * rateMutableStr = [NSMutableString stringWithString:rateStr];
        [rateMutableStr insertString:@"%" atIndex:rateMutableStr.length-2];
        //将%号设置为9号字体
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:rateMutableStr];
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = QNDFont(9);
        attrs[NSForegroundColorAttributeName] = QNDRGBColor(199, 168, 123);
        
        NSRange rang1 = [rateMutableStr rangeOfString:@"%"];
        [attrStr addAttributes:attrs range:rang1];
        return attrStr;
    }
}


@end
