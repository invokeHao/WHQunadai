//
//  QNDMineReplyTableViewCell.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDMineReplyTableViewCell.h"
#import "NSString+extention.h"
#import "QNDMineRelyListModel.h"

#import "QNDReplyTextCell.h"

@interface QNDMineReplyTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)NSMutableArray * replyArr;//回复列表

@end

@implementation QNDMineReplyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    //背景
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4;
    backView.clipsToBounds = YES;
    [self.contentView addSubview:backView];
    
    _proIconView = [[UIImageView alloc]init];
    _proIconView.layer.cornerRadius = 13;
    _proIconView.clipsToBounds = YES;
    [backView addSubview:_proIconView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = QNDFont(16.0);
    _nameLabel.textColor = black31TitleColor;
    [backView addSubview:_nameLabel];
    
    UIView * crowsLine = [[UIView alloc]init];
    crowsLine.backgroundColor = QNDRGBColor(242, 242, 242);
    [backView addSubview:crowsLine];
    
    UILabel * mineLabel = [[UILabel alloc]init];
    mineLabel.text = @"我：";
    mineLabel.textColor = black31TitleColor;
    mineLabel.font = QNDFont(14.0);
    [backView addSubview:mineLabel];
    
    _contentBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth-50, 40)];
    _contentBackView.image = [[UIImage imageNamed:@"Rectangle 22"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backView addSubview:_contentBackView];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = QNDFont(14);
    _contentLabel.textColor = QNDRGBColor(148, 156, 173);
    _contentLabel.numberOfLines = 0;
    [_contentBackView addSubview:_contentLabel];
    
    //回复的table
    self.MainTable = [[UITableView alloc] init];
    self.MainTable.scrollEnabled = NO;
    self.MainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.MainTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    self.MainTable.delegate = self;
    self.MainTable.dataSource = self;
    [backView addSubview:self.MainTable];
    
    //开始布局
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@0);
        make.right.equalTo(@-12);
        make.bottom.equalTo(@-10);
    }];
    
    [_proIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@12);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_proIconView);
        make.left.mas_equalTo(_proIconView.mas_right).with.offset(8);
        make.height.equalTo(@17);
    }];
    
    [crowsLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_proIconView.mas_bottom).with.offset(12);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.height.equalTo(@1);
    }];
    
    [_contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@38);
        make.right.equalTo(@-12);
        make.top.mas_equalTo(crowsLine.mas_bottom).with.offset(18);
        make.height.equalTo(@40);
    }];

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(@10);
    }];
    
    [mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.mas_equalTo(crowsLine.mas_bottom).with.offset(28);
        make.height.equalTo(@15);
    }];
    
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentBackView);
        make.right.equalTo(@-12);
        make.top.mas_equalTo(_contentBackView.mas_bottom).with.offset(5);
        make.bottom.equalTo(@0);
    }];
}

-(void)setModel:(QNDMineReplyModel *)model{
    if (model) {
        _model = model;
        [_proIconView sd_setImageWithURL:[NSURL URLWithString:_model.productIcon] placeholderImage:[UIImage imageNamed:@"default_t_icon"]];
        _nameLabel.text = _model.productName;
        _contentLabel.text = _model.content;
        if (_model.content.length>0) {
            CGFloat textH = [_model.content sizeWithFont:QNDFont(14.0) maxSize:CGSizeMake(ViewWidth-70, MAXFLOAT)].height;
            CGFloat textW = [model.content sizeWithAttributes:@{NSFontAttributeName : QNDFont(14.0)}].width + 25;
            
            if (textW>ViewWidth-50) {
                textW = ViewWidth-50;
            }
            [_contentBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_proIconView.mas_bottom).with.offset(30);
                make.left.equalTo(@38);
                make.size.mas_equalTo(CGSizeMake(textW, textH+20));
            }];
        }
        self.replyArr = self.model.replyList;
        [self.MainTable reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.replyArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.replyArr.count>0) {
       QNDMineRelyListModel  * model = self.replyArr[indexPath.row];
        return [model cellHeight];
    }else{
        return 40;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QNDReplyTextCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"QNDReplyTextCell"];
    if (!textCell) {
        textCell = [[QNDReplyTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDReplyTextCell"];
    }
    if (self.replyArr.count>0) {
        [textCell setModel:self.replyArr[indexPath.row]];
    }
    return textCell;
}

-(NSMutableArray *)replyArr{
    if (!_replyArr) {
        _replyArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _replyArr;
}


@end
