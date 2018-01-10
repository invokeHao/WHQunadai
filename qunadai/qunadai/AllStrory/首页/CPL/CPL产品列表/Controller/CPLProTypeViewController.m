//
//  CPLProTypeViewController.m
//  qunadai
//
//  Created by wang on 2017/11/23.
//  Copyright © 2017年 Fujian Qidian Financial Information Service Co., Ltd. All rights reserved.
//

#import "CPLProTypeViewController.h"
#import "CPLApplicationDetailViewController.h"

#import "CPLProductModel.h"
#import "productLoanModel.h"

#import "CPLProductListTableViewCell.h"
#import "loanProductTableViewCell.h"
#import "WangWebViewController.h"
#import "NullDefaultView.h"

#import "QNDProUnappliedListApi.h"
#import "CPLApplicationListApi.h"
#import "QNDApplicationOrderApi.h"
#import "CPLLonginApi.h"
#import "QNDCPLApplicationListApi.h"


@interface CPLProTypeViewController ()<UITableViewDelegate,UITableViewDataSource,YTKChainRequestDelegate>

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)NSMutableArray * dataArray;

@property (assign,nonatomic)int currentPage;

@end

@implementation CPLProTypeViewController
{
    NullDefaultView * nullView;//占位图
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
    [self setupData];
    NOTIF_POST(KNOTIFICATION_APPLICATION, @NO);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"已申请";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupRefresh{
    @WHWeakObj(self);
    @WHStrongObj(self);
    self.MainTable.mj_header = [WHRefreshHeader headerWithRefreshingBlock:^{
        Strongself.currentPage = 0;
        [Strongself.dataArray removeAllObjects];
        [Strongself setupData];
    }];
    self.MainTable.mj_footer = [WHRefreshFooter footerWithRefreshingBlock:^{
        Strongself.currentPage++;
        [Strongself setupData];
    }];
}

-(void)layoutViews{
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

-(void)createNullView{
    if (!nullView) {
        nullView = [[NullDefaultView alloc]initWithFrame:self.view.bounds andDescStr:@"您还没有在专区申请过产品"];
        [self.view addSubview:nullView];
    }
}


#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 157;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CPLProductListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CPLProductListTableViewCell"];
    if (!cell) {
        cell = [[CPLProductListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLProductListTableViewCell"];
    }
    CPLProductModel * model = self.dataArray[indexPath.row];
    if (model) {
        [cell setModel: model];
        [cell ShowTheApplicationStatus:YES];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPLProductModel * model = self.dataArray[indexPath.row];
    CPLApplicationDetailViewController * applicationVC = [[CPLApplicationDetailViewController alloc]init];
    applicationVC.proModel = model;
    applicationVC.application_id = model.application_id;
    [self.navigationController pushViewController:applicationVC animated:YES];
}

-(void)setupData{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    if (!KGetCPLTOKEN) {
        //获取新的cpltoken
        [self setupTheCPLToken];
    }else{
        [self setupAppliedListData];
    }
}

#pragma mark-获取已申请列表
-(void)setupAppliedListData{
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    QNDCPLApplicationListApi * QNDApi = [[QNDCPLApplicationListApi alloc]init];
    CPLApplicationListApi * CPLApi = [[CPLApplicationListApi alloc]init];
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    [chain addRequest:QNDApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        WHLog(@"%@,%@",baseRequest.responseJSONObject,baseRequest.error);
        NSInteger status = [[baseRequest responseJSONObject][@"status"]integerValue];
        if (status==1) {
            NSArray * sourceArr = [baseRequest responseJSONObject][@"data"];
            for (NSDictionary * dic in sourceArr) {
                CPLProductModel * model = [[CPLProductModel alloc]initWithDictionary:dic];
                model.isQND = YES;
                [self.dataArray addObject:model];
            }
        }
        [chainRequest addRequest:CPLApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            NSDictionary * soucreDic = [baseRequest responseJSONObject];
            [[WHLoading ShareInstance]hidenHud];
            NSArray * sourceArr = soucreDic[@"data"];
            if ([soucreDic[@"status_code"] integerValue] == 403) {
                //CPLToken过期，自动重新获取token
                [self setupTheCPLToken];
                return ;
            }else if ([soucreDic[@"status_code"] integerValue] == 200){
                if ([sourceArr isKindOfClass:[[NSNull null]class]]) {
                    return;
                }
                for (NSDictionary * dic in sourceArr) {
                    CPLProductModel * model = [[CPLProductModel alloc]initWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
        }];
    }];
    chain.delegate = self;
    [chain start];
}

#pragma mark-获取新的CPLToken
-(void)setupTheCPLToken{
    CPLLonginApi * CPlApi = [[CPLLonginApi alloc]initWithparamDic:@{@"app_id":CPLAPPID,@"app_psw":CPLAPPSecret,                                                                              @"mobile_number":KGetQNDPHONENUM}];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [CPlApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary * dic = [request responseJSONObject][@"data"];
        WHLog(@"dic==%@",dic);
        [user setObject:dic[@"token"] forKey:CPLUserToken];
        //重新获取到token
        [self setupAppliedListData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [[WHLoading ShareInstance]hidenHud];
    }];
}

-(void)setupOrderTheApplicationWithProCode:(NSString*)proCode{
    if (!KGetACCESSTOKEN) {
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
        return;
    }
    QNDApplicationOrderApi * api = [[QNDApplicationOrderApi alloc]initWithProCode:proCode];
    [[WHTool shareInstance]GetDataFromApi:api andCallBcak:^(NSDictionary *dic) {
        self.currentPage = 0;
        [self.dataArray removeAllObjects];
        [self setupData];
    }];
}

-(void)chainRequestFinished:(YTKChainRequest *)chainRequest{
    [[WHLoading ShareInstance]hidenHud];
    if (self.dataArray.count<1) {
        [self createNullView];
        return;
    }
    [self.MainTable reloadData];
}

-(void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request{
    WHLog(@"%@",request.error);
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

@end
