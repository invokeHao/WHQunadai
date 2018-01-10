//
//  QNDChildTableViewController.h
//  qunadai
//
//  Created by wang on 2017/9/7.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

typedef enum : NSUInteger {
    HotPorType, //热门列表
    LatestProType, //最新口子
    UnapplicationProType,  //未申请列表
    ApplicationProType,   //已申请列表
} QNDProListType;

#import <UIKit/UIKit.h>

@interface QNDChildTableViewController : UITableViewController

@property (strong,nonatomic)NSMutableArray * dataArray;

@property (copy,nonatomic)void(^NumberBlock)(NSInteger number);


-(instancetype)initWithPropertyType:(QNDProListType)type;

-(instancetype)initWithPropertyType:(QNDProListType)type andNum:(void(^)(NSInteger number))num;

-(void)setDataArray:(NSMutableArray *)dataArray;

-(void)setTopHeight:(CGFloat)height;

-(void)setTitleStr:(NSString *)str andValue:(NSInteger)value;

@property (assign,nonatomic)int currentpage;

-(void)setupData;

@end
