//
//  bannerTableViewCell.h
//  qunadai
//
//  Created by wang on 17/4/1.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "bannerModel.h"


typedef void(^BannerBlcok)(NSString * pid, NSString * name);

#import <UIKit/UIKit.h>

@interface bannerTableViewCell : UITableViewCell

@property (strong,nonatomic)BannerBlcok Bblcok;

@property (strong,nonatomic)NSMutableArray * dataArray;

-(void)setBblcok:(BannerBlcok)Bblcok;

-(void)setDataArray:(NSMutableArray *)dataArray;

@end
