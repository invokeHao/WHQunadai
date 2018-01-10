//
//  bannerTableViewCell.m
//  qunadai
//
//  Created by wang on 17/4/1.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "bannerTableViewCell.h"
#import "SDCycleScrollView.h"

#import "QNDBannerBrowseAmount.h"

@interface bannerTableViewCell() <SDCycleScrollViewDelegate>
{
    SDCycleScrollView * cycleScrollView;
}
@end

@implementation bannerTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = grayBackgroundLightColor;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, 140) delegate:self placeholderImage:[UIImage imageNamed:@"banner_pleaseholder"]];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.contentView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.bottom.equalTo(@0);
    }];
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 2.5;
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
        _Bblcok(model.actionUrl,model.bannerName);
    }
}

-(void)setupBannerDataWithBannerId:(NSString*)bannerId{
    QNDBannerBrowseAmount * api = [[QNDBannerBrowseAmount alloc]initWithBannerId:bannerId];
    [[WHTool shareInstance]GetDataFromApi:api andCallBcak:^(NSDictionary *dic) {
    }];
}


@end
