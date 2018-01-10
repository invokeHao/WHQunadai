//
//  QNDProReplyListTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/10/9.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDProReplyListTableViewCell.h"
#import "WHVerify.h"

@implementation QNDProReplyListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:_iconView];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = QNDFont(14.0);
    _contentLabel.textColor = QNDRGBColor(109, 109, 109);
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.font = QNDFont(10.0);
    _dateLabel.textColor = QNDRGBColor(153, 153, 153);
    [self.contentView addSubview:_dateLabel];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@16);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).with.offset(10);
        make.top.equalTo(@16);
        make.right.equalTo(@-12);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentLabel);
        make.bottom.equalTo(@-16);
        make.height.equalTo(@11);
    }];
}

-(void)setModel:(QNDProductReplyListModel *)model{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.useravatar] placeholderImage:[UIImage imageNamed:@"head_boy"]];
    NSString * nameStr = @"";
    if ([WHVerify checkTelNumber:_model.usernick]) {
        NSString*bStr = [_model.usernick substringWithRange:NSMakeRange(3,4)];
        NSString * phone = [_model.usernick stringByReplacingOccurrencesOfString:bStr withString:@"****"];
        nameStr = FORMAT(@"%@：",phone);
    }else{
        nameStr = FORMAT(@"%@：",_model.usernick);
    }
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:FORMAT(@"%@%@",nameStr,_model.content)];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(14);
    attrs[NSForegroundColorAttributeName] = black31TitleColor;
    
    NSRange rang1 = {0,nameStr.length};
    [attrStr addAttributes:attrs range:rang1];
    
    _contentLabel.attributedText = attrStr;
    
    _dateLabel.text = [_model GetThecreat_time:_model.createdTime];
    
}

@end
