//
//  QNDChildTableViewController.m
//  qunadai
//
//  Created by wang on 2017/9/7.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDChildTableViewController.h"
#import "DetailProductViewController.h"
#import "DetailProductViewController.h"
#import "WangWebViewController.h"

#import "loanProductTableViewCell.h"

#import "QNDProHotListApi.h"
#import "QNDNewLoanListApi.h"
#import "QNDProUnappliedListApi.h"
#import "QNDProApplicationListApi.h"
#import "QNDApplicationOrderApi.h"
#import "QNDProductPVCollectApi.h"

#import "NSString+extention.h"


@interface QNDChildTableViewController ()<YTKChainRequestDelegate,UITableViewDelegate,UITableViewDataSource>

@property (assign,nonatomic)QNDProListType listType;//贷款排序类型

@property (assign,nonatomic)NSInteger UnapplicationNum;//未申请数量

@property (assign,nonatomic)NSInteger applicationNum;//已申请数量

@property (strong,nonatomic)UILabel * slogenLabel;

@property (copy,nonatomic)NSString * bannerStr;

@property (strong,nonatomic)UIView * NullView;//占位view

@property (assign,nonatomic)CGFloat topHeight;
@end

@implementation QNDChildTableViewController
{
    UILabel * alterLabel;//提示label
    UIButton * loginBtn;//提示登录btn
    UILabel * applyLabel;
    UILabel * endlabel;
    UILabel * tipLabel;
}
-(instancetype)initWithPropertyType:(QNDProListType)type{
  self = [super init];
    _currentpage = 1;
    _listType = type;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    return self;
}

-(instancetype)initWithPropertyType:(QNDProListType)type andNum:(void (^)(NSInteger))num{
    self = [super init];
    if (self) {
        _currentpage = 1;
        _listType = type;
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        self.NumberBlock = num;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = grayBackgroundLightColor;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //自定义footerview
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (KIOS11Later) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupRefresh{
    @WHWeakObj(self);
    @WHStrongObj(self);
    self.tableView.mj_footer = [WHRefreshFooter footerWithRefreshingBlock:^{
        _currentpage++;
        [Strongself setupData];
    }];
}

-(UIView*)setupHeaderView{
    UIView * groundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, _topHeight+40)];
    groundView.backgroundColor = [UIColor clearColor];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40)];
    backView.backgroundColor = [UIColor clearColor];
    [groundView addSubview:backView];
    
    _slogenLabel = [[UILabel alloc]init];
    _slogenLabel.font = QNDFont(13.0);
    _slogenLabel.textColor = QNDRGBColor(189, 189, 189);
    _slogenLabel.text = @"所有平台不上征信，共可借180000元";
    _slogenLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_slogenLabel];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@42);
    }];
    
    [_slogenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backView);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@14);
    }];
    return groundView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 157;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    loanProductTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"loanpoductListCell"];
    if (!cell) {
        cell = [[loanProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loanpoductListCell"];
    }
    if (self.dataArray.count>0) {
        [cell setModel:self.dataArray[indexPath.row]];
    }
    @WHWeakObj(self);
    @WHStrongObj(self);
    [cell setOrderB:^(NSString * pid,NSString * name){
        //操作
        if (!KGetACCESSTOKEN) {
            [[WHTool shareInstance]GoToLoginWithFromVC:self];
            return;
        }
        [[WHTool shareInstance]showAlterViewWithMessage:FORMAT(@"您已经申请过(%@)了吗？",name) andDoneBlock:^(UIAlertAction * _Nonnull action) {
            [Weakself setupOrderTheApplicationWithProCode:pid];
        }];
    }];
    [cell setApplyB:^(NSString *name, NSString *url, NSString *pid) {
        if (!KGetACCESSTOKEN) {
            [[WHTool shareInstance]GoToLoginWithFromVC:self];
            return;
        }
        WangWebViewController * webVC = [[WangWebViewController alloc]init];
        webVC.webType = name;
        webVC.url = url;
        webVC.countStr = name;
        webVC.isProduct = YES;
        [webVC setBlock:^(NSString *pName) {
            [[WHTool shareInstance]showAlterViewWithMessage:FORMAT(@"您已经申请过(%@)了吗？",name) andDoneBlock:^(UIAlertAction * _Nonnull action){
                [Strongself setupOrderTheApplicationWithProCode:pid];
            }];
        }];
        [Strongself.navigationController pushViewController:webVC animated:YES];
        [Strongself setupThePVProductCollectWithType:QNDApplicateType andProductCode:pid];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (_dataArray.count<1) {
//        return;
//    }
//    DetailProductViewController * detailVC = [[DetailProductViewController alloc]init];
//    productLoanModel * model = _dataArray[indexPath.row];
//    detailVC.productCode = model.productCode;
//    detailVC.productId = FORMAT(@"%ld",model.IDS);
//    detailVC.model = model;
//    detailVC.needBack = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)setupData{
    switch (_listType) {
        case 0:{
            [self setupHotList];
            break;}
        case 1:{
            [self setupNewList];
            break;}
        case 2:{
            if (KGetACCESSTOKEN) {
                [self setupUnapplicationList];
            }else{
                [self setupHotList];
            }
            break;}
        case 3:{
            [self setupApplicationList];
            break;}
        default:
            break;
    }
}
#pragma mark -热门列表
-(void)setupHotList{
    QNDProHotListApi * api = [[QNDProHotListApi alloc]initWithPage:_currentpage];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSArray * sourceArr = request.responseJSONObject[@"data"][@"dataList"];
        for (NSDictionary * dic in sourceArr) {
            productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        if (sourceArr.count<1&&_currentpage>1) {
            _currentpage--;
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -最新口子
-(void)setupNewList{
    QNDNewLoanListApi * api = [[QNDNewLoanListApi alloc]initWithPage:_currentpage];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        WHLog(@"%@",request.responseJSONObject);
        NSArray * sourceArr = request.responseJSONObject[@"data"][@"dataList"];
        for (NSDictionary * dic in sourceArr) {
            productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        if (sourceArr.count<1&&_currentpage>1) {
            _currentpage--;
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -未申请列表
-(void)setupUnapplicationList{
    QNDProUnappliedListApi * api = [[QNDProUnappliedListApi alloc]initWithPage:_currentpage];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        WHLog(@"%@",request.responseJSONObject);
        NSArray * sourceArr = request.responseJSONObject[@"data"][@"dataList"];        for (NSDictionary * dic in sourceArr) {
            productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        if (sourceArr.count<1&&_currentpage>1) {
            _currentpage--;
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -已申请列表
-(void)setupApplicationList{
    QNDProApplicationListApi * api = [[QNDProApplicationListApi alloc]initWithPage:_currentpage];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        WHLog(@"%@",request.responseJSONObject);
        NSArray * sourceArr = request.responseJSONObject[@"data"][@"dataList"];        for (NSDictionary * dic in sourceArr) {
            productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
            model.applied = YES;
            [self.dataArray addObject:model];
        }
        if (sourceArr.count<1&&_currentpage>1) {
            _currentpage--;
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)setupOrderTheApplicationWithProCode:(NSString*)proCode{
    if (!KGetACCESSTOKEN) {
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
        return;
    }
    QNDApplicationOrderApi * api = [[QNDApplicationOrderApi alloc]initWithProCode:proCode];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        self.NumberBlock(1);//回调刷新数据
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

#pragma mark-PV统计
-(void)setupThePVProductCollectWithType:(WH_PVType)type andProductCode:(NSString*)code{
    QNDProductPVCollectApi * api = [[QNDProductPVCollectApi alloc]initProductCode:code andPVType:type];
    [[WHTool shareInstance]GetDataFromApi:api andCallBcak:^(NSDictionary *dic) {
        
    }];
}


-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    //显示占位用图
    if (_listType>1) {
        self.NullView.hidden = _dataArray.count > 0 ? YES : NO;
        self.tableView.tableHeaderView.hidden = !self.NullView.hidden;
        NSString * titleStr = @"此处显示已经申请过的口子，可以点击其他列表中的";
        if (_listType==2) {
            titleStr = @"哇！已经撸过所有的口子的啦。";
        }
        if (!KGetACCESSTOKEN) {
            titleStr = @"您还没有登录";
        }
        alterLabel.text = titleStr;
        
        tipLabel.hidden = _listType == 2 ? NO : YES;
        
        loginBtn.hidden = KGetACCESSTOKEN || _listType != 3;
        
        endlabel.hidden = applyLabel.hidden = !KGetACCESSTOKEN || _listType != 3;
    }
    [self.tableView reloadData];
}

-(void)setTitleStr:(NSString *)str andValue:(NSInteger)value{
    if (value!=1) {
        NSMutableString * vauleStr = [NSString getTheMutableStringWithString:FORMAT(@"%ld",value)];
        NSString * finishStr = FORMAT(@"所有平台%@，共可借%@元",str,vauleStr);
        
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:finishStr];
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = QNDFont(13);
        attrs[NSForegroundColorAttributeName] = ThemeColor;
        
        NSRange rang1 = [finishStr rangeOfString:str];
        [attrStr addAttributes:attrs range:rang1];
        
        NSRange rang2 = [finishStr rangeOfString:vauleStr];
        [attrStr addAttributes:attrs range:rang2];
        self.slogenLabel.attributedText = attrStr;
    }else{
        self.slogenLabel.text = str;
    }
}

-(void)setTopHeight:(CGFloat)height{
    _topHeight = height;
    self.tableView.tableHeaderView = [self setupHeaderView];
}

-(UIView *)NullView{
    if (!_NullView) {
        _NullView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        _NullView.backgroundColor = lightGrayBackColor;
        _NullView.hidden = YES;
        [self.view addSubview:_NullView];
        [self.view bringSubviewToFront:_NullView];
        //创建label
        alterLabel = [[UILabel alloc]init];
        alterLabel.font = QNDFont(12.0);
        alterLabel.textColor = QNDAssistText153Color;
        alterLabel.textAlignment = NSTextAlignmentCenter;
        [_NullView addSubview:alterLabel];
        
        tipLabel = [[UILabel alloc]init];
        tipLabel.font = QNDFont(12.0);
        tipLabel.textColor = ThemeColor;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"每天打开去哪贷看看，口子每天都会更新";
        [_NullView addSubview:tipLabel];

        applyLabel = [[UILabel alloc]init];
        applyLabel.font = QNDFont(13);
        applyLabel.textAlignment = NSTextAlignmentCenter;
        applyLabel.textColor = ThemeColor;
        applyLabel.layer.cornerRadius = 15;
        applyLabel.layer.borderColor = ThemeColor.CGColor;
        applyLabel.layer.borderWidth = 1.0;
        applyLabel.clipsToBounds = YES;
        applyLabel.text = @" 申请过了？";
        applyLabel.hidden = !KGetACCESSTOKEN;
        [_NullView addSubview:applyLabel];
        
        endlabel = [[UILabel alloc]init];
        endlabel.font = QNDFont(12.0);
        endlabel.textColor = QNDAssistText153Color;
        endlabel.text = @"确认后将会在此显示，方便日后管理";
        endlabel.hidden = !KGetACCESSTOKEN;
        endlabel.textAlignment = NSTextAlignmentCenter;
        [_NullView addSubview:endlabel];
        
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:QNDFont(16.0)];
        loginBtn.layer.cornerRadius = 2;
        loginBtn.layer.borderColor = ThemeColor.CGColor;
        loginBtn.layer.borderWidth = 1;
        loginBtn.clipsToBounds = YES;
        [loginBtn addTarget:self action:@selector(pressToLogin:) forControlEvents:UIControlEventTouchUpInside];
        [_NullView addSubview:loginBtn];
        
        //布局
        [alterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_NullView);
            make.top.equalTo(@264);
            make.height.equalTo(@13);
        }];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alterLabel.mas_bottom).with.offset(12);
            make.centerX.mas_equalTo(alterLabel);
            make.height.equalTo(@13);
        }];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(alterLabel);
            make.top.mas_equalTo(alterLabel.mas_bottom).with.offset(30);
            make.size.mas_equalTo(CGSizeMake(85, 30));
        }];
        
        [applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(alterLabel);
            make.top.mas_equalTo(alterLabel.mas_bottom).with.offset(12);
            make.size.mas_equalTo(CGSizeMake(82, 30));
        }];
        
        [endlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alterLabel.mas_bottom).with.offset(54);
            make.centerX.mas_equalTo(alterLabel);
            make.height.equalTo(@13);
        }];
    }
    return _NullView;
}

-(void)pressToLogin:(UIButton*)button{
    if (!KGetACCESSTOKEN) {
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
    }
}
@end
