//
//  QNDProductCommentTableViewCell.h
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//
@class QNDProductCommentListModel;

typedef void(^replyBlock)(NSString * cName,NSString * cId,UIButton * commentBtn);

typedef void(^moreBlock)(QNDProductCommentListModel * model);

#import <UIKit/UIKit.h>
#import "QNDProductCommentListModel.h"
#import "WHStarView.h"

@interface QNDProductCommentTableViewCell : UITableViewCell

@property (strong,nonatomic) UIImageView * iconView;

@property (strong,nonatomic) UILabel * nameLabel;

@property (strong,nonatomic) WHStarsView * starView;

@property (strong,nonatomic) UILabel * contentLabel;

@property (strong,nonatomic) UILabel * timeLabel;

@property (strong,nonatomic) UIImageView * contentBackView;//聊天背景

@property (strong,nonatomic) UIView * lineView;

@property (strong,nonatomic) QNDProductCommentListModel * model;

@property (strong,nonatomic) replyBlock replyB;

@property (strong,nonatomic) moreBlock moreB;

-(void)setModel:(QNDProductCommentListModel *)model;

-(void)setReplyB:(replyBlock)replyB;

-(void)setMoreB:(moreBlock)moreB;

@end
