//
//  QNDListBannerTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/9/15.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDListBannerTableViewCell.h"

@implementation QNDListBannerTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _bannerImageV = [[UIImageView alloc]init];
    _bannerImageV.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_bannerImageV];
    
    [_bannerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@1);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@-10);
    }];
    
}

@end
