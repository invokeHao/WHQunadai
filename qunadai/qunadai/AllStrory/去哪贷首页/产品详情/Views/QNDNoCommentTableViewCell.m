//
//  QNDNoCommentTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDNoCommentTableViewCell.h"

@implementation QNDNoCommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews{
    UIImageView * iconView = [[UIImageView alloc]init];
    [iconView setImage:[UIImage imageNamed:@"empty_review"]];
    [self.contentView addSubview:iconView];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = QNDFont(14.0);
    titleLabel.textColor = QNDRGBColor(153, 153, 153);
    titleLabel.text = @"还没有评论哦!";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.equalTo(@33);
        make.size.mas_equalTo(CGSizeMake(93, 57));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconView);
        make.top.mas_equalTo(iconView.mas_bottom).with.offset(10);
        make.height.equalTo(@15);
    }];
}
@end
