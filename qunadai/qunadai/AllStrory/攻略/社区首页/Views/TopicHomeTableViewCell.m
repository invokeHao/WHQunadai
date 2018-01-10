//
//  TopicHomeTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/5/12.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "TopicHomeTableViewCell.h"
#import "NSDate+Extension.h"

@interface TopicHomeTableViewCell ()

@property (strong,nonatomic) UIImageView * showIcon;

@property (strong,nonatomic) UILabel * contentLabel;

@property (strong,nonatomic) UILabel * readCountLabel;

@property (strong,nonatomic) UILabel * dateLabel;//日期label

@end

@implementation TopicHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    
    _showIcon = [[UIImageView alloc]init];
    _showIcon.layer.borderWidth = 0.5;
    _showIcon.layer.borderColor = QNDRGBColor(242, 242, 242).CGColor;
    _showIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_showIcon];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = QNDFont(16.0);
    _contentLabel.textColor = black31TitleColor;
    _contentLabel.numberOfLines = 2;
    [self.contentView addSubview:_contentLabel];
    
    UIImageView * readIcon = [[UIImageView alloc]init];
    [readIcon setImage:[UIImage imageNamed:@"readCount"]];
    [readIcon setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:readIcon];
    
    _readCountLabel = [[UILabel alloc]init];
    _readCountLabel.font = QNDFont(12.0);
    _readCountLabel.textColor = QNDAssistText153Color;
    [self.contentView addSubview:_readCountLabel];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.font = QNDFont(12.0);
    _dateLabel.textColor = QNDAssistText153Color;
    [self.contentView addSubview:_dateLabel];
    
#pragma mark-开始布局
    [_showIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(95, 95));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@16);
        make.right.mas_equalTo(_showIcon.mas_left).with.offset(-16);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.bottom.equalTo(@-16);
        make.height.equalTo(@13);
    }];
    
    [_readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_showIcon.mas_left).with.offset(-16);
        make.bottom.mas_equalTo(_dateLabel);
        make.height.equalTo(@13);
    }];
    
    [readIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_readCountLabel.mas_left).with.offset(-2);
        make.bottom.mas_equalTo(_dateLabel.mas_bottom).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(13, 9));
    }];
}

-(void)setModel:(TopicMainModel *)model{
    _model = model;
    _contentLabel.text = model.title;
    
    [_showIcon sd_setImageWithURL:[NSURL URLWithString:model.titleLogoUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _dateLabel.text = [NSDate getTheBrowsingStr:_model.createdTime];
    _readCountLabel.text = [NSString stringWithFormat:@"%ld",model.browseAmt];
}




@end
