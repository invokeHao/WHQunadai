//
//  QNDCustomHeaderView.h
//  qunadai
//
//  Created by wang on 2017/11/21.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WHAnnouncementLabel.h"


@protocol WHBannerDelegate <NSObject>

@optional

//判断点击banner以后逻辑判断

-(void)pressBannerActionUrl:(NSString*)url andName:(NSString *)name;

@end


@interface QNDCustomHeaderView : UIView 
/**
 cpl入口
 */
@property (assign,nonatomic)id<WHBannerDelegate> delegate;


@property (strong,nonatomic)NSMutableArray * dataArray;

//公告label
@property (strong,nonatomic)WHAnnouncementLabel * announceLabel;

/**
 修改y值
 */
- (void)changeY:(CGFloat)y;

-(void)setDataArray:(NSMutableArray *)dataArray;


@end
