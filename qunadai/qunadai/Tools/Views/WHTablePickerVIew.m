//
//  WHTableVIew.m
//  qunadai
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "WHTablePickerVIew.h"

#define KWHTablePickDuration 0.3
#define KWhTablePickCancelHeight 54

@interface WHTablePickerView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * WHtableView;
    UILabel* titleLabel ;
    CGFloat KWHTableViewH;
    UIView * visibleView;//tableview下方的view
}

@property (strong,nonatomic) NSArray * dataArray;

@property (strong,nonatomic) WHTabelBlock  ConfirmBlock;

@end

@implementation WHTablePickerView


+(void)showPickTableWithSouceArr:(NSArray *)sourceArr andSelectBlock:(WHTabelBlock )selectBlock{
    WHTablePickerView * tabelView = [[WHTablePickerView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    tabelView.dataArray = sourceArr;
    tabelView.ConfirmBlock = selectBlock;
    [tabelView initViews];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:tabelView];
    [tabelView show];
}

-(void)show{
    CGRect tableRect = visibleView.frame;
    tableRect.origin.y = ViewHeight - visibleView.height;
    [UIView animateWithDuration:KWHTablePickDuration animations:^{
        visibleView.frame = tableRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
}

-(void)dismiss{
    CGRect tableRect = visibleView.frame;
    tableRect.origin.y = ViewHeight;
    [UIView animateWithDuration:KWHTablePickDuration animations:^{
        visibleView.frame = tableRect;
        self.backgroundColor= [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


-(void)initViews{
    if (_dataArray.count>7) {
        KWHTableViewH = 44*7;
    }else{
        KWHTableViewH = _dataArray.count*44;
    }
    
    visibleView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, KWHTableViewH+KWhTablePickCancelHeight)];
    visibleView.backgroundColor = [UIColor clearColor];
    [self addSubview:visibleView];
    
    WHtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, KWHTableViewH)];
    WHtableView.backgroundColor = grayBackgroundLightColor;
    WHtableView.separatorColor = lightGrayBackColor;
    WHtableView.separatorInset = UIEdgeInsetsZero;
    WHtableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    WHtableView.delegate = self;
    WHtableView.dataSource = self;
    //添加取消按钮
    UIView * cancelView = [self createCancelViewWithFrame:CGRectMake(0, KWHTableViewH, ViewWidth, KWhTablePickCancelHeight)];
    [visibleView addSubview:cancelView];
    //添加手势
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight- visibleView.height)];
    backView.backgroundColor = [UIColor clearColor];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToDismiss:)];
    [backView addGestureRecognizer:tap];
    
    [visibleView addSubview:WHtableView];
}

-(UIView*)createCancelViewWithFrame:(CGRect)frame{
    UIView * cancelView = [[UIView alloc]initWithFrame:frame];
    cancelView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setCenter:CGPointMake(ViewWidth/2, 22+10)];
    [btn setBounds:CGRectMake(0, 0, ViewWidth, 44)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:black74TitleColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:QNDFont(14.0)];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:btn];
    return cancelView;
}

#pragma mark-tableView的代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

static NSString * cellID = @"WhTableViewCell";

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"WhTableViewCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"WhTableViewCell"];
    }
    UILabel * label = (UILabel*)[cell viewWithTag:10];
    if (label) {
        [label removeFromSuperview];
    }
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = QNDFont(14.0);
    titleLabel.textColor = black74TitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.tag = 10;
    [cell addSubview:titleLabel];
    
    [titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.centerY.mas_equalTo(cell.contentView);
        make.height.equalTo(@15);
    }];
    titleLabel.text = _dataArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        NSString * selectStr = _dataArray[indexPath.row];
        _ConfirmBlock(selectStr,indexPath.row);
    }
    [self dismiss];
}

#pragma mark - dismiss

-(void)tapToDismiss:(UITapGestureRecognizer*)tap{
    if (self) {
        [self dismiss];
    }
}



@end
