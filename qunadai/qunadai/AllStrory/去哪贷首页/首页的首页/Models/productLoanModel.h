//
//  productLoanModel.h
//  qunadai
//
//  Created by wang on 17/4/1.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productLoanModel : NSObject

@property (assign,nonatomic) NSInteger productId;//产品Id

@property (assign,nonatomic) NSInteger IDS;

@property (copy,nonatomic) NSString * productCode;//产品编码

@property (copy,nonatomic) NSString * productName;//产品名称

@property (copy,nonatomic) NSString * productUrl;//产品的H5链接

@property (copy,nonatomic) NSString * productLogoUrl;//logoURL

@property (copy,nonatomic) NSString * loanAmt;// 产品额度/元

@property (assign,nonatomic)NSInteger amtMin;//产品最小额度/元

@property (assign,nonatomic) NSInteger amtMax;//最大额度


@property (copy,nonatomic) NSString * productRate;//产品利率

@property (assign,nonatomic) CGFloat rateMin;//最小利率

@property (assign,nonatomic) CGFloat rateMax;//最大利率

@property (copy,nonatomic) NSString * rateUnit;//利率单位


@property (copy,nonatomic) NSString * productTerm;//产品期限

@property (assign,nonatomic) NSInteger termMin;//最小期限

@property (assign,nonatomic) NSInteger termMax;//最大期限

@property (copy,nonatomic) NSString * termUnit;//期限单位


@property (assign,nonatomic)NSInteger  loanNum;//放款人数

@property (assign,nonatomic)NSInteger loanRate;//成功率

@property (assign,nonatomic)NSInteger fastLoanTime;//最快放款时间

@property (copy,nonatomic)NSString * fastLoanTimeUnit;//最快放款时间单位

@property (copy,nonatomic)NSString * productConditions;//产品条件

@property (copy,nonatomic)NSString * productAdvantage;//产品优势

@property (copy,nonatomic)NSString * cooperationType;//合作方式

@property (copy,nonatomic) NSString * browsingTime;//浏览时间(浏览记录用)

@property (assign,nonatomic) NSInteger applied;//是否已申请 0-未申请 1-已申请(热门列表用)



-(instancetype)initWithDictionary:(NSDictionary*)dic;


-(CGFloat)textHeight;

-(NSString*)applyStr;

-(NSString *)getTheLoanTimeStr; //获取到放款时间

-(NSMutableAttributedString *)getTheLoanRateStr; //获取到放款利率

@end
