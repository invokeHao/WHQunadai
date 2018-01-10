//
//  TopicHomePageViewController.m
//  qunadai
//
//  Created by wang on 2017/5/12.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "TopicHomePageViewController.h"
#import "TopicDetailViewController.h"

#import "WangWebViewController.h"
#import "TopicHomePViewController.h"

#import "TopicHomeTableViewCell.h"
#import "bannerTableViewCell.h"

#import "bannerModel.h"

#import "QNDArticleListApi.h"
#import "QNDDiscoveryBannerApi.h"

@interface TopicHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL hasLoad;
}

@property (strong,nonatomic) UITableView * MainTable;

@property (strong,nonatomic) NSMutableArray * dataArray;

@property (assign,nonatomic) NSInteger currentPage;

@property (strong,nonatomic) NSMutableArray * bannerArray;

@end

@implementation TopicHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
    [self setupRefresh];
    _currentPage = 1;
    [self setupBannerList];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.navigationItem setRightBarButtonItems:nil];
    
    self.tabBarController.title = @"社区";
    [TalkingData trackEvent:@"发现" label:@"发现"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupRefresh{
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = weakSelf;
    self.MainTable.mj_header = [WHRefreshHeader headerWithRefreshingBlock:^{
        strongSelf.currentPage = 1;
        [strongSelf.dataArray removeAllObjects];
        [strongSelf setupData];
    }];
    self.MainTable.mj_footer = [WHRefreshFooter footerWithRefreshingBlock:^{
        strongSelf.currentPage++;
        [strongSelf setupData];
    }];
}

-(void)layoutViews{
    _MainTable = [[UITableView alloc]initWithFrame:(CGRect){0,0,ViewWidth,ViewHeight-49} style:UITableViewStylePlain];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    [self.view addSubview:_MainTable];
    
    if (KIOS11Later) {
        self.MainTable.estimatedRowHeight = 0;
        self.MainTable.estimatedSectionHeaderHeight = 0;
        self.MainTable.estimatedSectionFooterHeight = 0;
    }
}

#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.bannerArray.count>0) {
        return 2;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.bannerArray.count>0) {
        if (section==0) {
            return 1;
        }else{
            return self.dataArray.count;
        }
    }else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bannerArray.count>0) {
        if (indexPath.section==0) {
            return 180 * ViewWidth / 375;
        }else{
            return 134;
        }
    }else{
        return 134;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bannerArray.count>0) {
        if (indexPath.section==0) {
            bannerTableViewCell * bannerCell = [[bannerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bannerCell"];
            if (self.bannerArray.count>0) {
                [bannerCell setDataArray:self.bannerArray];
            }
            [bannerCell setBblcok:^(NSString *pid ,NSString * name) {
                @WHWeakObj(self);
                WangWebViewController * WebVC = [[WangWebViewController alloc]init];
                WebVC.webType = name;
                WebVC.url = pid;
                WebVC.countStr = name;
                [Weakself.navigationController pushViewController:WebVC animated:YES];
            }];
            return bannerCell;
        }else{
            TopicHomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopicHomeTableViewCell"];
            if (!cell) {
                cell = [[TopicHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopicHomeTableViewCell"];
            }
            if (_dataArray.count>0) {
                [cell setModel:_dataArray[indexPath.row]];
            }
            return cell;
        }
    }else{
        TopicHomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopicHomeTableViewCell"];
        if (!cell) {
            cell = [[TopicHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopicHomeTableViewCell"];
        }
        if (_dataArray.count>0) {
            [cell setModel:_dataArray[indexPath.row]];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&self.bannerArray.count>0) {
        return;
    }else{
        if (self.dataArray.count<1) {
            return;
    }
    TopicMainModel * model = self.dataArray[indexPath.row];
//    TopicDetailViewController * topicVC = [[TopicDetailViewController alloc]init];
//    topicVC.model  = model;
//    topicVC.topicId = FORMAT(@"%ld",model.IDS);
//    [self.navigationController pushViewController:topicVC animated:YES];
        WangWebViewController * webVC = [[WangWebViewController alloc]init];
        webVC.url = FORMAT(@"%@#/strategy/%ld?app=ios",WYBaseUrl,model.IDS);
        webVC.webType = @"详情";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark- 网络请求
-(void)setupBannerList{
    if (self.bannerArray.count>0) {
        [self.bannerArray removeAllObjects];
    }
    QNDDiscoveryBannerApi * api = [[QNDDiscoveryBannerApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            NSArray * listArr = [request responseJSONObject][@"data"];
            for (NSDictionary * dic in listArr) {
                bannerModel * model = [[bannerModel alloc]initWithDictionary:dic];
                [self.bannerArray addObject:model];
            }
            [self.MainTable reloadData];
        }else{
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

-(void)setupData{
    [[WHLoading ShareInstance]hidenHud];
    if (!hasLoad) {
        [[WHLoading ShareInstance]showImageHUD:self.view];
    }
    QNDArticleListApi * api  = [[QNDArticleListApi alloc]initWithPage:FORMAT(@"%ld",_currentPage)];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSInteger status = [[request responseJSONObject][@"status"]integerValue];
        if (status==1) {
            NSArray * listArr = [request responseJSONObject][@"data"][@"dataList"];
            for (NSDictionary * dic in listArr) {
                TopicMainModel * model = [[TopicMainModel alloc]initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            hasLoad = YES;
            [self.MainTable reloadData];
        }else{
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
        [self.MainTable.mj_header endRefreshing];
        [self.MainTable.mj_footer endRefreshing];
        [[WHOopsView shareInstance]hidenTheOops];
        [[WHLoading ShareInstance]hidenHud];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [[WHLoading ShareInstance]hidenHud];
        if (request.responseStatusCode==0) {
            [[WHLoading ShareInstance]hidenHud];
            [self.MainTable.mj_header endRefreshing];
            [self.MainTable.mj_footer endRefreshing];
            
            if (self.dataArray.count>0) {
                self.currentPage = 1;
                [self.dataArray removeAllObjects];
            }
            @WHWeakObj(self);
            [[WHOopsView shareInstance]showTheOopsViewOneTheView:self.view WithDoneBlock:^{
                [Weakself setupData];
            }];
        }
    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

-(NSMutableArray*)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _bannerArray;
}

-(NSInteger)currentPage{
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}



@end
