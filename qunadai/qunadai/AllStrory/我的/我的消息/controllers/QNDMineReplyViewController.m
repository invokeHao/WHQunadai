//
//  QNDMineReplyViewController.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDMineReplyViewController.h"

#import "QNDMineReplyModel.h"
#import "QNDMineRelyListModel.h"

#import "QNDMineReplyTableViewCell.h"
#import "NullDefaultView.h"

#import "QNDMineReplyListApi.h"

@interface QNDMineReplyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)NSMutableArray * commentArr;

@property (assign,nonatomic)int currentPage;

@end

@implementation QNDMineReplyViewController
{
    NullDefaultView * nullView;//占位图
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupData];
    self.title = @"我的消息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupRefresh{
    @WHWeakObj(self);
    @WHStrongObj(self);
    self.MainTable.mj_header = [WHRefreshHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [Strongself.commentArr removeAllObjects];
        [Strongself setupData];
    }];
    self.MainTable.mj_footer = [WHRefreshFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [Strongself setupData];
    }];
}


-(void)layoutViews{
    _currentPage = 0;
    self.view.backgroundColor = QNDRGBColor(242, 242, 242);
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = QNDRGBColor(242, 242, 242);
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.commentArr.count>0) {
        QNDMineReplyModel * model = self.commentArr[indexPath.row];
        return [model cellHeight];
    }else{
        return 120;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QNDMineReplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QNDMineReplyTableViewCell"];
    if (!cell) {
        cell = [[QNDMineReplyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDMineReplyTableViewCell"];
    }
    if (self.commentArr.count>0) {
        [cell setModel:self.commentArr[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)createNullView{
    if (!nullView) {
        nullView = [[NullDefaultView alloc]initWithFrame:self.view.bounds andDescStr:@"您还没有消息呦"];
        [self.view addSubview:nullView];
    }
}

-(void)setupData{
    QNDMineReplyListApi * api = [[QNDMineReplyListApi alloc]initWithPage:_currentPage];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSArray * sourceArr = [request responseJSONObject][@"content"][@"replied_comments"][@"content"];
        if (sourceArr.count<1&&_currentPage>0) {
            _currentPage--;
        }
        for (NSDictionary * dic in sourceArr) {
            QNDMineReplyModel * model = [[QNDMineReplyModel alloc]initWithDictionary:dic];
            [self.commentArr addObject:model];
        }
        if (self.commentArr.count<1) {
            [self createNullView];
        }
        [self.MainTable reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

-(NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _commentArr;
}




@end
