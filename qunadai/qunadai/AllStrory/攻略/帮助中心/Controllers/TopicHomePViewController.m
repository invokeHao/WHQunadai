//
//  TopicHomePViewController.m
//  qunadai
//
//  Created by wang on 17/3/22.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "TopicHomePViewController.h"
#import "helpDetailViewController.h"

#import "HelpTableViewCell.h"
#import "helpInfoModel.h"


@interface TopicHomePViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView * MainTable;

@property (strong,nonatomic) NSMutableArray * dataArray;


@end

@implementation TopicHomePViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
    [self setupRefresh];
    [self readDataFromPlist];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    if (_isToHelp) {
        self.title = @"帮助中心";
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupRefresh{
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = weakSelf;
    self.MainTable.mj_header = [WHRefreshHeader headerWithRefreshingBlock:^{
        [strongSelf setupData];
    }];
    self.MainTable.mj_footer = [WHRefreshFooter footerWithRefreshingBlock:^{
        [strongSelf setupData];
    }];
}


-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    _MainTable = [[UITableView alloc]init];
    self.MainTable.backgroundColor = grayBackgroundLightColor;
    self.MainTable.separatorColor = lightGrayBackColor;
    self.MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.MainTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    __weak id weakSelf = self;
    _MainTable.delegate = weakSelf;
    _MainTable.dataSource = weakSelf;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@-49);
    }];
    if (_isToHelp) {
        [_MainTable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HelpTableViewCell"];
    if (cell==nil) {
        cell = [[HelpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HelpTableViewCell"];
    }
    helpInfoModel * model = _dataArray[indexPath.row];
    cell.titleLabel.text = model.question;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    helpInfoModel * model = _dataArray[indexPath.row];
    helpDetailViewController * helpDetailVC = [[helpDetailViewController alloc]init];
    helpDetailVC.helpModel =model;
    [self.navigationController pushViewController:helpDetailVC animated:YES];
}

-(void)readDataFromPlist{
    //工程自身的plist
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"help" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSArray * arr = dataDic[@"list"];
    for (NSDictionary* dic in arr) {
        helpInfoModel * model = [[helpInfoModel alloc]initWithDictionary:dic];
        [self.dataArray addObject:model];
    }
    [_MainTable reloadData];
}

-(void)setupData{
    sleep(1.5);
    [self.MainTable.mj_header endRefreshing];
    [self.MainTable.mj_footer endRefreshing];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


@end
