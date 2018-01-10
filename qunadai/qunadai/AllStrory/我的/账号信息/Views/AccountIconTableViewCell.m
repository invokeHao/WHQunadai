//
//  AccountIconTableViewCell.m
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "AccountIconTableViewCell.h"

@implementation AccountIconTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    UILabel * TitleLabel = [[UILabel alloc]init];
    TitleLabel.font = QNDFont(14.0);
    TitleLabel.textColor = black74TitleColor;
    TitleLabel.text = @"头像";
    [self.contentView addSubview:TitleLabel];
    
    _IconView = [[UIImageView alloc]init];
    _IconView.layer.cornerRadius = 25;
    _IconView.clipsToBounds = YES;
    [self.contentView addSubview:_IconView];
    
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.equalTo(@15);
    }];
    
    [_IconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}
@end
