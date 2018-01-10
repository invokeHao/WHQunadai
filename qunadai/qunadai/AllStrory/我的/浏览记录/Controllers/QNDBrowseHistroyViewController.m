//
//  QNDBrowseHistroyViewController.m
//  qunadai
//
//  Created by wang on 2017/9/8.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDBrowseHistroyViewController.h"
#import "DetailProductViewController.h"

#import "QNDLoanHisTableViewCell.h"
#import "YellowAlertTableViewCell.h"
#import "NullDefaultView.h"

#import "productLoanModel.h"

#import "QNDBrowseHisListApi.h"
#import "QNDBrowseListDeleApi.h"

@interface QNDBrowseHistroyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL hasDelete;//删除掉上方的提示
    NullDefaultView * nullView;//占位图
}

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)NSMutableArray * dataArray;

@end

@implementation QNDBrowseHistroyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"浏览记录";
    [self setupNavBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavBtn{
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [deleteBtn setImage:[UIImage imageNamed:@"content_icon_rubbish"] forState:UIControlStateNormal];
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [deleteBtn addTarget:self action:@selector(pressToDeleteTheHistory) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * myItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    [self.navigationItem setRightBarButtonItem:myItem];
}

-(void)layoutViews{
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _MainTable.separatorColor = lightGrayBackColor;
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
    if (hasDelete) {
        return 1;
    }else{
        return 2;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (hasDelete) {
        if (section==0) {
            return self.dataArray.count;
        }else{
            return 1;
        }
    }else{
        if (section==0) {
            return 1;
        }else{
            return self.dataArray.count;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (hasDelete) {
        return 157;
    }else{
        if (indexPath.section==0) {
            return 32;
        }else{
            return 157;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = weakSelf;
    if (hasDelete) {
        QNDLoanHisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QNDLoanHisTableViewCell"];
        if (!cell) {
            cell = [[QNDLoanHisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDLoanHisTableViewCell"];
        }
        [cell setModel:self.dataArray[indexPath.row]];
        return cell;
    }else{
        if (indexPath.section==0) {
            YellowAlertTableViewCell * yellowCell = [[YellowAlertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yellowAlertCell"];
            yellowCell.alertLabel.text = FORMAT(@"您共浏览了%ld项贷款机构",self.dataArray.count);
            [yellowCell setYellowBlock:^{
                //删除提示cell
                hasDelete = YES;
                [strongSelf.MainTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [strongSelf.MainTable performSelector:@selector(reloadData) withObject:nil afterDelay:0.5f];
            }];
            return yellowCell;
        }else{
            QNDLoanHisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QNDLoanHisTableViewCell"];
            if (!cell) {
                cell = [[QNDLoanHisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDLoanHisTableViewCell"];
            }
            [cell setModel:self.dataArray[indexPath.row]];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (hasDelete) {
        if (indexPath.section==0) {
            DetailProductViewController * detailVC = [[DetailProductViewController alloc]init];
            productLoanModel * model = _dataArray[indexPath.row];
            detailVC.productCode = model.productCode;
            detailVC.productId = FORMAT(@"%ld",model.productId);
            detailVC.model = model;
            detailVC.needBack = NO;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else{
        if (indexPath.section==1) {
            DetailProductViewController * detailVC = [[DetailProductViewController alloc]init];
            productLoanModel * model = _dataArray[indexPath.row];
            detailVC.productCode = model.productCode;
            detailVC.productId = FORMAT(@"%ld",model.productId);
            detailVC.model = model;
            detailVC.needBack = NO;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

-(void)setupData{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    QNDBrowseHisListApi * api = [[QNDBrowseHisListApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        WHLog(@"succ==%@",[request responseJSONObject]);
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            NSArray * sourceArr = [request responseJSONObject][@"data"][@"dataList"];
            sourceArr.count < 1 ? [self createNullView] : [nullView removeFromSuperview];
            for (NSDictionary * dic in sourceArr) {
                productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            [[WHOopsView shareInstance]hidenTheOops];
            [self.MainTable reloadData];
        }else{
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        if (request.responseStatusCode==0) {
            [[WHLoading ShareInstance]hidenHud];
            [self.dataArray removeAllObjects];
            @WHWeakObj(self);
            [[WHOopsView shareInstance]showTheOopsViewOneTheView:self.view WithDoneBlock:^{
                [Weakself setupData];
            }];
        }
    }];
}

#pragma mark- 删除记录
-(void)pressToDeleteTheHistory{
    @WHWeakObj(self);
    @WHStrongObj(self);
    [[WHTool shareInstance]showAlterViewWithMessage:@"确定清空记录吗" andDoneBlock:^(UIAlertAction * _Nonnull action) {
        [[WHLoading ShareInstance]showImageHUD:self.view];
        QNDBrowseListDeleApi * api = [[QNDBrowseListDeleApi alloc]init];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [[WHLoading ShareInstance]hidenHud];
            [Strongself.dataArray removeAllObjects];
            [Strongself.MainTable reloadData];
            [Strongself createNullView];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            WHLog(@"%@",request.error);
        }];
    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


-(void)createNullView{
    if (!nullView) {
        nullView = [[NullDefaultView alloc]initWithFrame:self.view.bounds andDescStr:@"您还没有浏览记录呦"];
        [self.view addSubview:nullView];
    }
}



@end
