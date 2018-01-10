//
//  QNDProductCommentTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDProductCommentTableViewCell.h"
#import "NSString+extention.h"
#import "WHVerify.h"

@implementation QNDProductCommentTableViewCell
{
    UIButton * replyBtn;
    UIView * _replyView;//回复的view
    UIButton * _moreReplyBtn;//查看更多回复的btn
    UILabel * replyNamelabel;
    UILabel * replyContentLabel;
    UILabel * replyTimeLabel;//回复的时间label
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _iconView = [[UIImageView alloc]init];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.layer.cornerRadius = 16;
    _iconView.clipsToBounds = YES;
    [self.contentView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = QNDFont(14.0);
    _nameLabel.textColor = black31TitleColor;
    [self.contentView addSubview:_nameLabel];
    
    //星星
    _starView = [[WHStarsView alloc]initWithStarSize:CGSizeMake(10, 10) margin:2 numberOfStars:5];
    _starView.allowSelect = NO;  // 默认可点击
    _starView.allowDecimal = NO;  //默认可显示小数
    _starView.allowDragSelect = NO;//默认不可拖动评分，可拖动下需可点击才有效
    [self.contentView addSubview:_starView];

    _contentBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth-108, 40)];
     _contentBackView.image = [[UIImage imageNamed:@"Rectangle 22"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.contentView addSubview:_contentBackView];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = QNDFont(14);
    _contentLabel.textColor = QNDRGBColor(109, 109, 109);
    _contentLabel.numberOfLines = 0;
    [_contentBackView addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = QNDFont(10);
    _timeLabel.textColor = QNDRGBColor(153, 153, 153);
    
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = lightGrayBackColor;
    [self.contentView addSubview:_lineView];
    
    replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [replyBtn setTitleColor:QNDRGBColor(153, 153, 153) forState:UIControlStateNormal];
    [replyBtn.titleLabel setFont:QNDFont(12.0)];
    [replyBtn setTitleEdgeInsets:UIEdgeInsetsMake(1, 2, 6, 2)];
    [replyBtn addTarget:self action:@selector(pressToreply:) forControlEvents:UIControlEventTouchUpInside];
    replyBtn.hidden = YES;
    [self.contentView addSubview:replyBtn];
    
    //评论的回复
    _replyView = [[UIView alloc]init];
    _replyView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_replyView];
    
    replyNamelabel = [[UILabel alloc]init];
    replyNamelabel.font = QNDFont(14.0);
    replyNamelabel.textColor = black31TitleColor;
    [_replyView addSubview:replyNamelabel];
    
    replyContentLabel = [[UILabel alloc]init];
    replyContentLabel.font = QNDFont(14.0);
    replyContentLabel.textColor = QNDRGBColor(109, 109, 109);
    replyContentLabel.numberOfLines = 4;
    [_replyView addSubview:replyContentLabel];
    
    replyTimeLabel = [[UILabel alloc]init];
    replyTimeLabel.font = QNDFont(10);
    replyTimeLabel.textColor = QNDRGBColor(153, 153, 153);
    [_replyView addSubview:replyTimeLabel];
    
    _moreReplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreReplyBtn setTitle:@"点击查看更多回复" forState:UIControlStateNormal];
    [_moreReplyBtn setTitleColor:QNDRGBColor(153, 153, 153) forState:UIControlStateNormal];
    [_moreReplyBtn.titleLabel setFont:QNDFont(12.0)];
    [_moreReplyBtn addTarget:self action:@selector(pressToSeeMoreReply:) forControlEvents:UIControlEventTouchUpInside];
    [_moreReplyBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [self.contentView addSubview:_moreReplyBtn];
    
    //开始布局
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@12);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).with.offset(10);
        make.centerY.mas_equalTo(_iconView);
        make.height.equalTo(@15);
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(_iconView);
        make.size.mas_equalTo(CGSizeMake(60, 10));
    }];
    
    [_contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.right.equalTo(@-54);
        make.top.mas_equalTo(_iconView.mas_bottom).with.offset(10);
        make.height.equalTo(@40);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(@10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_contentBackView.mas_bottom).with.offset(6);
        make.height.equalTo(@11);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    [replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.mas_equalTo(_iconView);
        make.size.mas_equalTo(CGSizeMake(30, 24));
    }];
    
    [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeLabel);
        make.right.equalTo(@-10);
        make.bottom.equalTo(@-47);
    }];
    
    [replyNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.equalTo(@15);
    }];
    
    [replyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(replyNamelabel.mas_right).with.offset(5);
        make.right.equalTo(@0);
        make.top.equalTo(@-2);
    }];
    
    [replyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(replyContentLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(replyContentLabel);
        make.height.equalTo(@11);
    }];
    
    [_moreReplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.bottom.equalTo(@-16);
        make.size.mas_equalTo(CGSizeMake(73, 17));
    }];
}

-(void)setModel:(QNDProductCommentListModel *)model{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.useravatar] placeholderImage:[UIImage imageNamed:@"head_boy"]];
    //判断如果昵称为手机号，需要将其中四位隐藏
    if ([WHVerify checkTelNumber:_model.username]) {
        NSString*bStr = [self.model.username substringWithRange:NSMakeRange(3,4)];
        NSString * phone = [self.model.username stringByReplacingOccurrencesOfString:bStr withString:@"****"];
        _nameLabel.text = phone;
    }else{
        _nameLabel.text = _model.username;
    }
    _contentBackView.hidden = _model.content.length > 0 ? NO : YES;

    if (_model.content.length>0) {
        CGFloat textH = [model.content sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-128, MAXFLOAT)].height;
        CGFloat textW = [model.content sizeWithAttributes:@{NSFontAttributeName : QNDFont(14.0)}].width + 25;
        
        if (textW>ViewWidth-108) {
            textW = ViewWidth-108;
        }
        [_contentBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_iconView.mas_bottom).with.offset(10);
            make.left.mas_equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(textW, textH+20));
        }];
    }
    _starView.score = _model.stars;
    _contentLabel.text = _model.content;
    _timeLabel.text = [_model GetThecreat_time:_model.createdTime];
    //回复部分
    QNDProductReplyListModel * replyModel = _model.replyModel;
    _moreReplyBtn.hidden = _model.replyNumber > 1 && _model.replyModel ? NO : YES;
    _replyView.hidden = replyModel.replyId.length>1 ? NO : YES;

    if (replyModel.replyId.length>1) {
        [_replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentBackView.mas_bottom).with.offset(30);
            make.left.mas_equalTo(_timeLabel);
            make.right.equalTo(@-10);
            make.bottom.equalTo(@-47);
        }];
        if ([WHVerify checkTelNumber:_model.replyModel.usernick]) {
            NSString*bStr = [_model.replyModel.usernick substringWithRange:NSMakeRange(3,4)];
            NSString * phone = [_model.replyModel.usernick stringByReplacingOccurrencesOfString:bStr withString:@"****"];
            replyNamelabel.text = FORMAT(@"%@：",phone);
        }else{
            replyNamelabel.text = FORMAT(@"%@：",_model.replyModel.usernick);
        }
        replyContentLabel.text = replyModel.content;
        replyTimeLabel.text = [_model GetThecreat_time:replyModel.createdTime];
    }else{
        [_replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    [_moreReplyBtn setTitle:FORMAT(@"共%ld条回复",_model.replyNumber) forState:UIControlStateNormal];
    [_moreReplyBtn layoutIfNeeded];//使用masony切记这一句
    _moreReplyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _moreReplyBtn.titleLabel.width + 2.5, 0, -_moreReplyBtn.titleLabel.width - 2.5);
    _moreReplyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_moreReplyBtn.currentImage.size.width, 0, _moreReplyBtn.currentImage.size.width);
}

-(void)pressToreply:(UIButton*)button{
    NSString * nickStr = @"";
    if ([WHVerify checkTelNumber:_model.username]) {
        NSString*bStr = [_model.username substringWithRange:NSMakeRange(3,4)];
        NSString * phone = [_model.username stringByReplacingOccurrencesOfString:bStr withString:@"****"];
        nickStr = FORMAT(@"回复%@",phone);
    }else{
        nickStr = FORMAT(@"回复%@",_model.username);
    }
    _replyB(nickStr,_model.commentId,replyBtn);
}

-(void)pressToSeeMoreReply:(UIButton*)button{
    QNDProductCommentListModel * model = [[QNDProductCommentListModel alloc]initWithModel:self.model];
    _moreB(model);
}

@end
