//
//  QNDCustomHeaderView.m
//  qunadai
//
//  Created by wang on 2017/11/21.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "QNDCustomHeaderView.h"
#import "SDCycleScrollView.h"

#import "CPLCreditListModel.h"
#import "bannerModel.h"

#import "CPLUserCreditsListApi.h"
#import "QNDBannerBrowseAmount.h"
#import "CPLLonginApi.h"

@interface QNDCustomHeaderView()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView * cycleScrollView;
}

@end

@implementation QNDCustomHeaderView 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 创建cplView
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"banner_pleaseholder"]];
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        [self addSubview:cycleScrollView];
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@-44);
        }];
        //         --- 轮播时间间隔，默认1.0秒，可自定义
        cycleScrollView.autoScrollTimeInterval = 2.5;
        
    }
    return self;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    NSMutableArray * imageUrlArr = [NSMutableArray array];
    for (bannerModel * model in dataArray) {
        [imageUrlArr addObject:model.bannerPicUrl];
    }
    cycleScrollView.imageURLStringsGroup = imageUrlArr;
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (_dataArray.count >0) {
        bannerModel * model = [_dataArray objectAtIndex:index];
        //统计banner点击量
        [self setupBannerDataWithBannerId:FORMAT(@"%ld",model.IDS)];
        //如果h5链接以#开头则不跳转
        if ([model.actionUrl hasPrefix:@"#"]) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(pressBannerActionUrl:andName:)]) {
            [self.delegate pressBannerActionUrl:model.actionUrl andName:model.bannerName];
        }
    }
}

-(void)setupBannerDataWithBannerId:(NSString*)bannerId{
    QNDBannerBrowseAmount * api = [[QNDBannerBrowseAmount alloc]initWithBannerId:bannerId];
    [[WHTool shareInstance]GetDataFromApi:api andCallBcak:^(NSDictionary *dic) {
    }];
}

- (void)changeY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y+64;
    self.frame = frame;
}

// 禁掉手势
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if ([view isKindOfClass:UIScrollView.class]) {
//        return view;
//    }
//    //判断如果点击的是imageview 才可以点击
//    if ([view isKindOfClass:UIImageView.class]) {
//        return view;
//    }
//    return nil;
//}



@end
