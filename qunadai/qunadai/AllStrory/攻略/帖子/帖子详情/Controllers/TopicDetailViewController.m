//
//  TopicDetailViewController.m
//  qunadai
//
//  Created by wang on 2017/5/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#define SuiJiShu(a) (arc4random()%a)


#import "TopicDetailViewController.h"
#import "QNDProductSegementViewController.h"

#import "TopicDetailTableViewCell.h"

#import "QNDArticleDetailApi.h"


@interface TopicDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL needUpdateOffset;
}
@property (strong,nonatomic)UITableView * MainTable;

@property (assign,nonatomic)CGFloat history_Y_offset;

@property (assign,nonatomic)CGFloat seletedCellHeight;

@property (assign,nonatomic)NSInteger currentPage;

@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
    [self setdata];
    _currentPage = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"详情";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    _MainTable = [[UITableView alloc]initWithFrame:(CGRect){0,0,ViewWidth,ViewHeight} style:UITableViewStylePlain];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, CGFLOAT_MIN)];
    [self.view addSubview:_MainTable];
    
    if (KIOS11Later) {
        self.MainTable.estimatedRowHeight = 0;
        self.MainTable.estimatedSectionHeaderHeight = 0;
        self.MainTable.estimatedSectionFooterHeight = 0;
    }
}

-(void)setupLoanBtn{
    UIButton * loanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loanBtn setTitle:@" 立即贷款" forState:UIControlStateNormal];
    [loanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loanBtn setBackgroundColor:ThemeColor];
    [loanBtn.titleLabel setFont:QNDFont(18.0)];
    [loanBtn setFrame:CGRectMake(ViewWidth-110, ViewHeight/3*2, 110, 41)];
    [loanBtn addTarget:self action:@selector(pressToLoan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loanBtn];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:loanBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = loanBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.path = maskPath.CGPath;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = lightGrayBackColor.CGColor;
    lineLayer.lineWidth = 1.0;
    lineLayer.frame = CGRectMake(0, 0, 115, 46);

    CAShapeLayer* borderLayer = [CAShapeLayer layer];
    borderLayer.path = maskPath.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.lineWidth = 5;
    borderLayer.frame = loanBtn.bounds;
    
    loanBtn.layer.mask = maskLayer;

    [borderLayer addSublayer:lineLayer];
    [loanBtn.layer addSublayer:borderLayer];
}



-(UIView*)createHeaderView{
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 35)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]init];
    label.font = QNDFont(13.0);
    label.textColor = black31TitleColor;
    label.text = @"评论";
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.mas_equalTo(header);
        make.height.equalTo(@14);
    }];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, header.height-0.5, ViewWidth, 0.5)];
    lineView.backgroundColor = lightGrayBackColor;
    [header addSubview:lineView];
    return header;
}


#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_model detailCellHeight];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicDetailTableViewCell * topcell = [tableView dequeueReusableCellWithIdentifier:@"TopicDetailTableViewCell"];
    if (!topcell) {
        topcell = [[TopicDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopicDetailTableViewCell"];
    }
    if (self.model) {
        [topcell setModel:self.model];
    }
    return topcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)pressToLoan:(UIButton*)button{
    QNDProductSegementViewController * allVC = [QNDProductSegementViewController new];
    allVC.selectedIndex = 0;
    [self.navigationController pushViewController:allVC animated:YES];
}

-(void)setdata{
    QNDArticleDetailApi * api = [[QNDArticleDetailApi alloc]initWithArticleId:_topicId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        WHLog(@"%@",request.responseJSONObject);
        if (status==1) {
            NSDictionary * dic = request.responseJSONObject[@"data"];
            self.model = [[TopicMainModel alloc]initWithDictionary:dic];
            [self.MainTable reloadData];
        }else{
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [[WHLoading ShareInstance]hidenHud];
    }];
}

@end
