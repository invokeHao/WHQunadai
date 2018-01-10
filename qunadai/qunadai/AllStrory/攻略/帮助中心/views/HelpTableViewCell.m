//
//  HelpTableViewCell.m
//  qunadai
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "HelpTableViewCell.h"

@implementation HelpTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


-(void)createUI{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = QNDFont(15.0);
    _titleLabel.textColor = blackTitleColor;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.equalTo(@15);
    }];
    
    UIImageView * moreView = [[UIImageView alloc]init];
    [moreView setImage:[UIImage imageNamed:@"goin"]];
    [moreView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:moreView];
    
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
}


@end
