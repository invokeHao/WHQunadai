//
//  QNDReplyTextCell.m
//  qunadai
//
//  Created by wang on 2017/11/9.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDReplyTextCell.h"
#import "WHVerify.h"

@interface QNDReplyTextCell ()

@property (strong,nonatomic)UILabel * contentLabel;

@end

@implementation QNDReplyTextCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = QNDFont(14.0);
    _contentLabel.textColor = QNDRGBColor(181, 188, 204);
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    //开始布局
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
    }];
}

-(void)setModel:(QNDProductReplyListModel *)model{
    if (model) {
        _model = model;
        NSString * nickStr = @"";
        if ([WHVerify checkTelNumber:_model.usernick]) {
            NSString*bStr = [_model.usernick substringWithRange:NSMakeRange(3,4)];
            NSString * phone = [_model.usernick stringByReplacingOccurrencesOfString:bStr withString:@"****"];
            nickStr = FORMAT(@"%@：",phone);
        }else{
            nickStr = FORMAT(@"%@：",_model.usernick);
        }
        NSString * MStr = FORMAT(@"%@%@",nickStr,_model.content);
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:MStr];
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = QNDFont(14.0);
        attrs[NSForegroundColorAttributeName] = black31TitleColor;
        
        NSRange rang1 = [MStr rangeOfString:nickStr];
        [attrStr addAttributes:attrs range:rang1];
        _contentLabel.attributedText = attrStr;
    }
}


@end
