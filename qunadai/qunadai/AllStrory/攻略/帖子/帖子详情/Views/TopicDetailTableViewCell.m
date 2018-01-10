//
//  TopicDetailTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/5/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "TopicDetailTableViewCell.h"
#import "NSDate+Extension.h"

@interface TopicDetailTableViewCell ()

@property (strong,nonatomic) UILabel * userLabel;

@property (strong,nonatomic) UILabel * readAcountLabel;

@property (strong,nonatomic) UILabel * contentLabel;

@end

@implementation TopicDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutViews{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = QNDFont(19.0);
    _titleLabel.textColor = blackTitleColor;
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _userLabel = [[UILabel alloc]init];
    _userLabel.font = QNDFont(12.0);
    _userLabel.textColor = QNDAssistText153Color;
    [self.contentView addSubview:_userLabel];
    
    UIImageView * readIcon = [[UIImageView alloc]init];
    [readIcon setImage:[UIImage imageNamed:@"readCount"]];
    [readIcon setContentMode:UIViewContentModeScaleAspectFill];

    [self.contentView addSubview:readIcon];
    
    _readAcountLabel = [[UILabel alloc]init];
    _readAcountLabel.font = QNDFont(12);
    _readAcountLabel.textColor = QNDAssistText153Color;
    [self.contentView addSubview:_readAcountLabel];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = QNDFont(16.0);
    _contentLabel.textColor = blackTitleColor;
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
        
    //开始布局
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.top.equalTo(@15);
    }];
    
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(20);
        make.left.mas_equalTo(@12);
        make.height.equalTo(@11);
    }];
    
    [_readAcountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(19);
        make.height.equalTo(@11);
    }];
    
    [readIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_readAcountLabel.mas_left).with.offset(-3);
        make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(19);
        make.size.mas_equalTo(CGSizeMake(13, 9));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(47);
    }];
}

-(void)setModel:(TopicMainModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    
    _readAcountLabel.text = [NSString stringWithFormat:@"%ld",model.browseAmt];
    _contentLabel.text = model.content;
    
    NSString * userStr = [NSString stringWithFormat:@"%@  | %@",model.createdUser,[NSDate create_time:model.createdTime]];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:userStr];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(13);
    attrs[NSForegroundColorAttributeName] = blackTitleColor;
    
    NSRange rang = {0,model.createdUser.length};
    [attrStr addAttributes:attrs range:rang];

    
    _userLabel.attributedText = attrStr;
}

@end
