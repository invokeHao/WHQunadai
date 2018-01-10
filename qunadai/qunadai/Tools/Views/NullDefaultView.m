//
//  NullDefaultView.m
//  qunadai
//
//  Created by wang on 2017/5/7.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "NullDefaultView.h"

@implementation NullDefaultView
{
    NSString * _descStr;
}
-(instancetype)initWithFrame:(CGRect)frame andDescStr:(NSString *)desc{
    self= [super initWithFrame:frame];
    if (self) {
        _descStr = desc;
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * iconView = [[UIImageView alloc]init];
    iconView.contentMode = UIViewContentModeCenter;
    [iconView setImage:[UIImage imageNamed:@"noneLoan_icon"]];
    [self addSubview:iconView];
    
    UILabel * label = [[UILabel alloc]init];
    label.font = QNDFont(15.0);
    label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    label.text =  _descStr;
    label.textAlignment =NSTextAlignmentCenter;
    [self addSubview:label];
    
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.equalTo(@150);
        make.size.mas_equalTo(CGSizeMake(110, 100));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).with.offset(50);
        make.centerX.mas_equalTo(iconView);
        make.height.equalTo(@16);
    }];
}



@end
