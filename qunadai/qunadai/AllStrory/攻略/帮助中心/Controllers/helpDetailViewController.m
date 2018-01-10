

//
//  helpDetailViewController.m
//  qunadai
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "helpDetailViewController.h"
#import "NSString+extention.h"

@interface helpDetailViewController ()

@end

@implementation helpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"问题详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    self.view.backgroundColor = grayBackgroundLightColor;
    
    CGSize  maxSize = CGSizeMake(ViewWidth-30, MAXFLOAT);
    CGFloat Y = 0.0 ;
    NSArray * answerArr = [_helpModel.answer componentsSeparatedByString:@"n"];
    if (answerArr.count<2) {
        Y = [_helpModel.answer sizeWithFont:QNDFont(14.0) maxSize:maxSize].height;

    }else{
        for (NSString * str in answerArr) {
            Y +=[str sizeWithFont:QNDFont(14.0) maxSize:maxSize].height;
        }
    }
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+64, ViewWidth, Y+44+20)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: backView];
    
    UILabel * questionLabel = [[UILabel alloc] init];
    questionLabel.font = QNDFont(15.0);
    questionLabel.textColor = blackTitleColor;
    questionLabel.text = _helpModel.question;
    [backView addSubview:questionLabel];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = lightGrayBackColor;
    [backView addSubview:lineView];
    
    
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@14.5);
        make.height.equalTo(@15);
    }];
        
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(questionLabel.mas_bottom).with.offset(14.5);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@0.5);
    }];
    
    if (answerArr.count<2) {
        UILabel * contentLabel = [[UILabel alloc]init];
        contentLabel.font = QNDFont(14.0);
        contentLabel.textColor = blackTitleColor;
        contentLabel.text = _helpModel.answer;
        
        contentLabel.numberOfLines = 0;
        [backView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.right.equalTo(@-15);
            make.top.mas_equalTo(lineView.mas_bottom).with.offset(10);
        }];
    }else{
        int i =0;
        CGFloat Y = 45+5;
        for (NSString * str in answerArr) {
            CGFloat strH = 0;
            strH=[str sizeWithFont:QNDFont(14.0) maxSize:maxSize].height;
            UILabel * label = [self createLabelWithText:str andFrame:CGRectMake(15, Y+5, ViewWidth-30, strH)];
            [backView addSubview:label];
            Y += strH;
            i++;
        }
    }

    
}

-(UILabel * )createLabelWithText:(NSString*)text andFrame:(CGRect)frame{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = QNDFont(14.0);
    label.textColor = blackTitleColor;
    label.numberOfLines = 0;
    return  label;
}
                         


@end
