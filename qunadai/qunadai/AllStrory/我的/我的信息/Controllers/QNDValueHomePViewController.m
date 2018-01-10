//
//  ValueHomePViewController.m
//  qunadai
//
//  Created by wang on 17/3/22.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDValueHomePViewController.h"
#import "BankVerifyViewController.h"
#import "RealInfoViewController.h"
#import "QNDLoginViewController.h"
#import "QNDProductSegementViewController.h"
#import "ControlAllNavigationViewController.h"
#import "wangTabBarController.h"
#import "AppDelegate.h"

#import "QNDValueTopTableViewCell.h"
#import "verifyTableViewCell.h"

#import "VerifyFunctionModel.h"
#import "ValueHomeModel.h"

#import "QNDMoXieVerifyListApi.h"
#import "MoxieSDK.h"
#import "QNDFuDataOperatorApi.h"

@interface QNDValueHomePViewController ()<UITableViewDelegate,UITableViewDataSource,MoxieSDKDelegate>
{
    BOOL hasload;//登录过
    BOOL hadVerify;//去验证回来
    NSMutableArray * verifyArr;//认证状态数组
    NSInteger selectRow;
    UIView * backview;
}
@property (strong,nonatomic)ValueHomeModel * model;//
@property (strong,nonatomic)UITableView * MainTable;
@property (strong,nonatomic)NSMutableArray * dataArray;

@end

@implementation QNDValueHomePViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self layoutViews];
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (KWHSUCCESS) {
        self.tabBarController.title = @"信息";
    }else{
        self.title = @"我的额度";
    }
    [self setupData];
    [TalkingData trackPageBegin:@"我的信息页面"];
    [TalkingData trackEvent:@"我的信息点击量" label:@"我的信息点击量"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    WHLog(@"viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"我的信息页面"];
}
-(void)dealloc{
    WHLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupNavigationBar{
    UIView * navigationbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 64)];
    navigationbarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navigationbarView];

    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    backview = [[UIVisualEffectView alloc]initWithEffect:beffect];
    [backview setFrame:navigationbarView.bounds];
    backview.hidden = YES;
    [navigationbarView addSubview:backview];
    
    UIButton * leftBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBackBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftBackBtn addTarget:self action:@selector(pressToBack) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:leftBackBtn];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = QNDFont(16.0);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"我的额度";
    [navigationbarView addSubview:titleLabel];
    
    [leftBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(@30);
        make.size.mas_equalTo(CGSizeMake(32, 22));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@31);
        make.centerX.mas_equalTo(navigationbarView);
        make.height.equalTo(@17);
    }];
}

-(void)setupRefresh{
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = weakSelf;
    self.MainTable.mj_header = [WHRefreshHeader headerWithRefreshingBlock:^{
        [strongSelf setupData];
    }];
}

-(void)layoutViews{
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 43, 0, 0);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.01)];
    __weak id weakSelf = self;
    _MainTable.delegate = weakSelf;
    _MainTable.dataSource = weakSelf;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    if (@available(iOS 11.0, *)) {
        _MainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _MainTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _MainTable.scrollIndicatorInsets = _MainTable.contentInset;
    }
}

-(void)pressToLoan{
    if (KWHSUCCESS) {
        ControlAllNavigationViewController * allNavVC = [[ControlAllNavigationViewController alloc]initWithRootViewController:[wangTabBarController new]];
        AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController=allNavVC;
    }else{
        QNDProductSegementViewController * VC = [[QNDProductSegementViewController alloc]init];
        VC.selectedIndex = 0;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)pressToBack{
    [self.navigationController popViewControllerAnimated:YES];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 128;
    }else{
        return 52;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        QNDValueTopTableViewCell *cell = [[QNDValueTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDValueTopTableViewCell"];
        if (!_model) {
            [cell setTheLoanValue:@"500"];
        }else{
            [cell setTheLoanValue:FORMAT(@"%ld",_model.loanLimit)];
        }
        return cell;
    }else{
        verifyTableViewCell * cell = [[verifyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"verifyCell"];
            VerifyFunctionModel * model = _dataArray[indexPath.row];
        if (verifyArr.count>0) {
            model.statu = verifyArr[indexPath.row];
            [cell setModel:model];
        }
            return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int a = 1;
    if (indexPath.section==a) {
        if (!KGetACCESSTOKEN) {
            [[WHTool shareInstance]GoToLoginWithFromVC:self];
            return;
        }else{
            [self configMoxieSDK];//配置魔蝎环境
        }
    }
    if (indexPath.section==a&&indexPath.row==0) {
        //银行卡认证
        BankVerifyViewController * bankVerifyVC = [[BankVerifyViewController alloc]init];
        [self.navigationController pushViewController:bankVerifyVC animated:YES];
        [TalkingData trackEvent:@"银行卡验证点击" label:@"银行卡验证点击"];
        
    }else if (indexPath.section ==a&&indexPath.row==1){
        //网银认证
        [self.navigationController.navigationBar setTintColor:ThemeColor];
        [MoxieSDK shared].taskType = @"bank";
        [[MoxieSDK shared] startFunction];
        [TalkingData trackEvent:@"网银验证点击" label:@"网银验证点击"];
    }else if (indexPath.section ==a &&indexPath.row==2){
        [self.navigationController.navigationBar setTintColor:ThemeColor];
        [MoxieSDK shared].taskType = @"carrier";
        //自定义运营商
        [[MoxieSDK shared] startFunction];
        [TalkingData trackEvent:@"运营商验证点击" label:@"运营商验证点击"];
    }else if (indexPath.section ==a &&indexPath.row==3){
        [self.navigationController.navigationBar setTintColor:ThemeColor];
        //支付宝
        [MoxieSDK shared].taskType = @"alipay";
        [[MoxieSDK shared] startFunction];
        [TalkingData trackEvent:@"支付宝验证点击" label:@"支付宝验证点击"];
    }else if (indexPath.section==a &&indexPath.row ==4){
        [self.navigationController.navigationBar setTintColor:ThemeColor];
        //邮箱
        [MoxieSDK shared].taskType = @"email";
        [[MoxieSDK shared] startFunction];
        [TalkingData trackEvent:@"邮箱验证点击" label:@"邮箱验证点击"];
    }else if (indexPath.section==a &&indexPath.row ==5){
        [self.navigationController.navigationBar setTintColor:ThemeColor];
        //公积金
        [MoxieSDK shared].taskType = @"fund";
        [[MoxieSDK shared] startFunction];
        [TalkingData trackEvent:@"公积金验证点击" label:@"公积金验证点击"];
    }else if (indexPath.section==a &&indexPath.row ==6){
        [self.navigationController.navigationBar setTintColor:ThemeColor];
        //淘宝
        [MoxieSDK shared].taskType = @"taobao";
        [[MoxieSDK shared] startFunction];
        [TalkingData trackEvent:@"淘宝验证点击" label:@"淘宝验证点击"];
    }else if (indexPath.section==a &&indexPath.row ==7){
        [self.navigationController.navigationBar setTintColor:ThemeColor];
        //征信
        [MoxieSDK shared].taskType = @"zhengxin";
        [[MoxieSDK shared] startFunction];
        [TalkingData trackEvent:@"征信验证点击" label:@"征信验证点击"];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_MainTable.contentOffset.y > 12) {
        backview.hidden = NO;
    }else{
        backview.hidden = YES;
    }
}

-(void)setData{
    selectRow = 0;
    //工程自身的plist
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"verifyFunction" ofType:@"plist"];
    NSDictionary *dataDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSArray * listArr = dataDic[@"list"];
    int i = 0;
    for (NSDictionary * dic in listArr) {
        VerifyFunctionModel * model = [[VerifyFunctionModel alloc]initWithDictionary:dic];
        [self.dataArray addObject:model];
        i++;
    }
}

-(void)setVerifyStatus{
    verifyArr = [NSMutableArray arrayWithCapacity:0];
    if (self.model) {
        if (self.model.bankStatus) {
            [verifyArr addObject:self.model.bankStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (self.model.ebankStatus) {
            [verifyArr addObject:self.model.ebankStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (self.model.operatorStatus) {
//            [verifyArr addObject:@"ERROR"];
            [verifyArr addObject:self.model.operatorStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (self.model.alipayStatus) {
            [verifyArr addObject:self.model.alipayStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (self.model.emailStatus) {
            [verifyArr addObject:self.model.emailStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (self.model.fundStatus) {
            [verifyArr addObject:self.model.fundStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (self.model.taobaoStatus) {
            [verifyArr addObject:self.model.taobaoStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (self.model.zxStatus) {
            [verifyArr addObject:self.model.zxStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
    }
    //如果去认证过
    if (hadVerify) {
        //根据taskType判断认证了什么，然后根据状态判断弹出的toast
        [self showTheVerifyToast];
        hadVerify = NO;
    }
    int i = 0;
    for (NSString * tempStr in verifyArr) {
        if ([tempStr isEqualToString:@"SUCCESS"]) {
            i++;
        }
    }
}

-(void)showTheVerifyToast{
    
    VerifyFunctionModel * model = _dataArray[selectRow];
    model.statu = verifyArr[selectRow];
    if (model.type==verifySuccessType) {
        [self.view makeCenterToast:[NSString stringWithFormat:@"%@验证成功",model.name]];
    } else if (model.type==verifingType) {
        [self.view makeCenterToast:[NSString stringWithFormat:@"%@正在认证中 请先完成其他认证项",model.name] duration:2.4];
    }else if (model.type==verifyFailedType){
        [self.view makeCenterToast:[NSString stringWithFormat:@"%@认证失败 请重新填写认证",model.name]];
    }
}

#pragma mark-数据请求

-(void)setupData{
    if (!KGetACCESSTOKEN) {
        self.model = [[ValueHomeModel alloc]init];
        self.model.loanLimit = 500;
        [self setVerifyStatus];
        [self.MainTable reloadData];
        [self.MainTable.mj_header endRefreshing];
        return;
    }
    if (!hasload) {
        [[WHLoading ShareInstance]hidenHud];
        [[WHLoading ShareInstance]showImageHUD:self.view];
    }
    QNDMoXieVerifyListApi * Moxieapi = [[QNDMoXieVerifyListApi alloc]init];
    [Moxieapi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",[request responseJSONObject]);
        [[WHLoading ShareInstance]hidenHud];
        hasload = YES;
        [self.MainTable.mj_header endRefreshing];
        NSDictionary * sourcedic = [request responseJSONObject][@"data"];
        _model = [[ValueHomeModel alloc]initWithDictionary:sourcedic];
        [self setVerifyStatus];
        [self.MainTable reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        [self.MainTable.mj_header endRefreshing];
        WHLog(@"%@",[request responseJSONObject]);
    }];
    
//    QNDFuDataOperatorApi * api = [[QNDFuDataOperatorApi alloc]init];
//    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        [[WHLoading ShareInstance]hidenHud];
//        WHLog(@"%@",request.responseJSONObject);
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        WHLog(@"%@",request.error);
//    }];
    
}
/**********************SDK 使用***********************/
-(void)configMoxieSDK{
    /***必须配置的基本参数*/
    [MoxieSDK shared].delegate = self;
    [MoxieSDK shared].userId = MXUserID;
    [MoxieSDK shared].apiKey = MXApiKey;
    [MoxieSDK shared].fromController = self;
    //-------------更多自定义参数，请参考文档----------------//
};

#pragma MoxieSDK Result Delegate
-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
    int code = [resultDictionary[@"code"] intValue];
    NSString *taskType = resultDictionary[@"taskType"];
    NSString *taskId = resultDictionary[@"taskId"];
    NSString *message = resultDictionary[@"message"];
    NSString *account = resultDictionary[@"account"];
    WHLog(@"get import result---code:%d,taskType:%@,taskId:%@,message:%@,account:%@",code,taskType,taskId,message,account);
    //用户没有做任何操作
    if(code == -1){
        WHLog(@"用户未进行操作");
    }
    //假如code是2则继续查询该任务进展
    else if(code == 2){
        WHLog(@"任务进行中，可以继续轮询");
    }
    //假如code是1则成功
    else if(code == 1){
        hadVerify = YES;
        WHLog(@"任务成功");
        if ([taskType isEqualToString:@"bank"]) {
            [TalkingData trackEvent:@"网银验证成功" label:@"网银验证成功"];
        }else if ([taskType isEqualToString:@"carrier"]){
            [TalkingData trackEvent:@"运营商验证成功" label:@"运营商验证成功"];
        }else if ([taskType isEqualToString:@"alipay"]){
            [TalkingData trackEvent:@"支付宝验证成功" label:@"支付宝验证成功"];
        }else if ([taskType isEqualToString:@"email"]){
            [TalkingData trackEvent:@"邮箱验证成功" label:@"邮箱验证成功"];
        }else if ([taskType isEqualToString:@"fund"]){
            [TalkingData trackEvent:@"公积金验证成功" label:@"公积金验证成功"];
        }else if ([taskType isEqualToString:@"taobao"]){
            [TalkingData trackEvent:@"淘宝验证成功" label:@"淘宝验证成功"];
        }else if ([taskType isEqualToString:@"zhengxin"]){
            [TalkingData trackEvent:@"征信验证成功" label:@"征信验证成功"];
        }
    }
    //该任务失败按失败处理
    else{
        WHLog(@"任务失败");
    }
    WHLog(@"任务结束，可以根据taskid，在租户管理系统查询该次任何的最终数据，在魔蝎云监控平台查询该任务的整体流程信息。SDK只会回调状态码及部分基本信息，完整数据会最终通过服务端回调。（记得将本demo的apikey修改成公司对应的正确的apikey）");
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


@end
