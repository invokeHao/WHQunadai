//
//  CPLProductListViewController.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLProductListViewController.h"
#import "CPLProductDetailViewController.h"
#import "CPLApplicationDetailViewController.h"

#import "WHSegmentedControl.h"
#import "CPLProductModel.h"
#import "JFLocation.h"

#import "CPLProductListTableViewCell.h"

#import "CPLProductListApi.h"
#import "CPLApplicationListApi.h"
#import "QNDLocationPostApi.h"

@interface CPLProductListViewController ()<WHSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,YTKChainRequestDelegate>

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)NSMutableArray * productArray;//可申请数据

@property (strong,nonatomic)NSMutableArray * applicationArray;//已申请数据

@property (strong,nonatomic)WHSegmentedControl * segment;

@property (strong,nonatomic)JFLocation * locationManager;

@property (assign,nonatomic)NSInteger selectIndex;//选中的下标

@end

@implementation CPLProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"极速专区";
    [self.navigationController.navigationBar setHidden:NO];
    [self setupData];
    [self setupLocation];
    [self setupBackNavigationBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupBackNavigationBtn{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [leftBtn setContentMode:UIViewContentModeScaleAspectFit];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(5, -2, 5, 20)];
    [leftBtn addTarget:self action:@selector(pressToBack:) forControlEvents:UIControlEventTouchUpInside];
    [[WHTool shareInstance]setupNavigationLeftButton:self LeftButton:leftBtn];
}

-(void)setupLocation{
    self.locationManager = [[JFLocation alloc]init];
    self.locationManager.delegate = self;
}


-(void)pressToBack:(UIButton*)button{
    WHLog(@"1111");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)layoutViews{
    self.view.backgroundColor = grayBackgroundLightColor;
    self.selectIndex = 0;
    self.segment = [[WHSegmentedControl alloc]initWithOriginY:64 Titles:@[@"可申请",@"已申请"] delegate:self];
    [self.view addSubview:self.segment];
    
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    _MainTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(_segment.mas_bottom).with.offset(0);
    }];
}


#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selectIndex==0) {
        return self.productArray.count;
    }else{
        return self.applicationArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CPLProductListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CPLProductListTableViewCell"];
    if (!cell) {
        cell = [[CPLProductListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLProductListTableViewCell"];
    }
    CPLProductModel * model = self.selectIndex == 0 ? self.productArray[indexPath.section] : self.applicationArray[indexPath.section];
    
    if (model) {
       [cell setModel: model];
        [cell ShowTheApplicationStatus: self.selectIndex==0 ? NO : YES];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectIndex==0) {
        CPLProductDetailViewController * detailVC =[[CPLProductDetailViewController alloc]init];
        detailVC.model = self.productArray[indexPath.section];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        CPLApplicationDetailViewController * applicationVC = [[CPLApplicationDetailViewController alloc]init];
        applicationVC.proModel = self.applicationArray[indexPath.section];
        [self.navigationController pushViewController:applicationVC animated:YES];
    }
}

#pragma mark- 请求数据
-(void)setupData{
    if (self.productArray.count>0) {
        [self.productArray removeAllObjects];
    }
    if (self.applicationArray.count>0) {
        [self.applicationArray removeAllObjects];
    }
    CPLProductListApi * productApi = [[CPLProductListApi alloc]init];
    CPLApplicationListApi * applicationApi = [[CPLApplicationListApi alloc]init];
    [[WHLoading ShareInstance]showImageHUD:self.view];
    
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    [chain addRequest:productApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        WHLog(@"%@",baseRequest.responseJSONObject);
        NSArray * sourceArr = [baseRequest responseJSONObject][@"data"];
        for (NSDictionary * dic in sourceArr) {
            CPLProductModel * model = [[CPLProductModel alloc]initWithDictionary:dic];
            [self.productArray addObject:model];
        }
        [chainRequest addRequest:applicationApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            WHLog(@"%@",baseRequest.responseJSONObject);
            NSArray * sourceArr = [baseRequest responseJSONObject][@"data"];
            if ([sourceArr isKindOfClass:[[NSNull null] class]]) {
                return ;
            }
            for (NSDictionary * dic in sourceArr) {
                CPLProductModel * model = [[CPLProductModel alloc]initWithDictionary:dic];
                [self.applicationArray addObject:model];
            }
        }];
    }];
    chain.delegate = self;
    [chain start];
}

#pragma mark- ytkchain delegate
-(void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request{
    [[WHLoading ShareInstance]hidenHud];
}

-(void)chainRequestFinished:(YTKChainRequest *)chainRequest{
    [[WHLoading ShareInstance]hidenHud];
    [self.MainTable reloadData];
}

#pragma mark-segement的代理

-(void)WHSegmentedControlSelectAtIndex:(NSInteger)index{
    self.selectIndex = index;
    if (self.applicationArray.count>0) {
        [self.MainTable setContentOffset:CGPointZero];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.MainTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [self.MainTable reloadData];
}


#pragma mark-懒加载
-(NSMutableArray *)productArray{
    if (!_productArray) {
        _productArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _productArray;
}

-(NSMutableArray*)applicationArray{
    if (!_applicationArray) {
        _applicationArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _applicationArray;
}


@end
