//
//  CPLApplicationDetailViewController.m
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLApplicationDetailViewController.h"
#import "CPLProductDetailViewController.h"

#import "CPLApplicationProCell.h"
#import "CPLApplicationProgress.h"
#import "CPLApplicationProCell.h"
#import "CPLProductListTableViewCell.h"
#import "CPLApplicationResultCell.h"

#import "CPLApplicationDetailModel.h"

#import "CPLApplicationDetailApi.h"
#import "CPLProductListApi.h"
#import "QNDApplicationDetailApi.h"
#import "QNDCPLProListApi.h"

@interface CPLApplicationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YTKChainRequestDelegate>

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)CPLApplicationProgress * progress;

@property (strong,nonatomic)NSMutableArray * dataArray;

@property (strong,nonatomic)CPLApplicationDetailModel * model;

@end

@implementation CPLApplicationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = self.proModel.name;
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    _MainTable.tableHeaderView = self.progress;
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.progress.type == ApplicationReject || self.progress.type==ApplicationSuccess) {
            return 223;
        }else{
            return 164;
        }
    }else{
        return 141;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.progress.type == ApplicationReject || self.progress.type == ApplicationSuccess) {
            CPLApplicationResultCell * resultCell = [[CPLApplicationResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLApplicationResultCell"];
            [resultCell setType:self.progress.type andTelNum:self.model.contact_number];
            return  resultCell;
        }else{
            CPLApplicationProCell * proCell = [[CPLApplicationProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLApplicationProCell"];
            [proCell setModel:self.model];
            return proCell;
        }
    }else{
        CPLProductListTableViewCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"CPLProductListTableViewCell"];
        if (!listCell) {
            listCell = [[CPLProductListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLProductListTableViewCell"];
        }
        if (self.dataArray.count>0) {
            [listCell setModel:self.dataArray[indexPath.row]];
        }
        return listCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        CPLProductDetailViewController * detailVC =[[CPLProductDetailViewController alloc]init];
        detailVC.model = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


-(void)setupData{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    YTKRequest * ApplicationApi;
    if (_application_id) {
        ApplicationApi = [[QNDApplicationDetailApi alloc]initWithApplicationId:_application_id];
    }else{
        ApplicationApi = [[CPLApplicationDetailApi alloc]initWithProductId:self.proModel.prId];
    }
    YTKRequest * listApi;
    if (_application_id) {
        listApi = [[QNDCPLProListApi alloc]init];
    }else{
        listApi = [[CPLProductListApi alloc]init];
    }

    YTKChainRequest * chain = [[YTKChainRequest alloc]init];

    [chain addRequest:ApplicationApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        WHLog(@"%@",baseRequest.responseJSONObject);
        NSInteger status = [[baseRequest responseJSONObject][@"status"] integerValue];
        if (status==1) {
            NSDictionary * sourceDic = [baseRequest responseJSONObject][@"data"];
            self.model = [[CPLApplicationDetailModel alloc]initWithDictionary:sourceDic];
        }else{
            [self.view makeToast:[baseRequest responseJSONObject][@"msg"]];
        }
        [chainRequest addRequest:listApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            NSArray * sourceArr = [baseRequest responseJSONObject][@"data"];
            for (NSDictionary * dic in sourceArr) {
                CPLProductModel * model = [[CPLProductModel alloc]initWithDictionary:dic];
                model.isQND = _application_id ? YES : NO;
                [self.dataArray addObject:model];
            }
        }];
    }];
    chain.delegate = self;
    [chain start];
}

-(void)chainRequestFinished:(YTKChainRequest *)chainRequest{
    [[WHLoading ShareInstance]hidenHud];
    self.model.icon_url = self.proModel.icon_url;
    self.model.name = self.proModel.name;
    [self.progress setType:self.proModel.applicationType];
    [self.MainTable reloadData];
}

-(void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request{
    [[WHLoading ShareInstance]hidenHud];
    [self.view makeToast:[request responseJSONObject][@"massage"]];
}


-(CPLApplicationProgress *)progress{
    if (!_progress) {
        _progress = [[CPLApplicationProgress alloc]initWithFinishStep:ApplicationInview andFrame:CGRectMake(0, 0, ViewWidth, 85)];
    }
    return _progress;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


@end
