//
//  QNDNewHomePageViewController.m
//  qunadai
//
//  Created by 王浩 on 2017/12/27.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDNewHomePageViewController.h"
#import "CPLProductDetailViewController.h"
#import "CPLBasicCreditViewController.h"
#import "WangWebViewController.h"

#import "WHAnnouncementLabel.h"
#import "WHShareView.h"

#import "bannerTableViewCell.h"
#import "QNDNewHPMidTableViewCell.h"
#import "QNDBottomBtnTableViewCell.h"
#import "QNDSamllCardTableViewCell.h"
#import "CPLProductListTableViewCell.h"

#import "bannerModel.h"
#import "CPLCreditListModel.h"
#import "CPLProductModel.h"
#import "JFLocation.h"

#import "QNDNewHomePageBannerApi.h"
#import "CPLUserCreditsListApi.h"
#import "CPLLonginApi.h"
#import "CPLProductListApi.h"
#import "QNDCPLProListApi.h"
#import "QNDLocationPostApi.h"



@interface QNDNewHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,YTKChainRequestDelegate,JFLocationDelegate>

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)JFLocation * locationManager;

@property (strong,nonatomic)WHAnnouncementLabel * announceLabel;

@property (strong,nonatomic)NSMutableArray * dataArray;//产品列表

@property (strong,nonatomic)NSMutableArray * QNDBannerArray;//qndBanner

@property (strong,nonatomic)bannerTableViewCell * bannerCell;//bannercell

@property (strong,nonatomic)QNDNewHPMidTableViewCell * midCell;

@property (strong,nonatomic)QNDBottomBtnTableViewCell * btnCell;

@property (strong,nonatomic)QNDSamllCardTableViewCell * smallCell;

@property (strong,nonatomic)CPLProductListTableViewCell * CPLCell;


@end

@implementation QNDNewHomePageViewController
{
    BOOL showTheList;//显示列表
    UIView * _announceView;
    NSString * _announceStr;
    NSInteger totalAmount;//总额度
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocation];
    [self judgeTheNOtification];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self judgeToShowTheProList];
    //创建右侧分享按钮
    [self setupRightNavightionBtn];
    self.tabBarController.title = @"去哪贷";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews{
    [self layoutViews];
}

-(void)setupLocation{
    self.locationManager = [[JFLocation alloc]init];
    self.locationManager.delegate = self;
}

-(void)judgeTheNOtification{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {
        [[WHTool shareInstance]showAlterViewWithTitle:@"您关闭了消息推送" Message:@"去哪贷每天都会更新新口子给您，请点击确认获取最新口子消息" cancelBtn:@"不获取新口子" doneBtn:@"获取最新口子"andVC:self andDoneBlock:^(UIAlertAction * _Nonnull action) {
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                [[UIApplication sharedApplication] openURL:settingUrl];
            }
        } andCancelBlock:^(UIAlertAction * _Nonnull action) {
        }];
    }else{
        WHLog(@"推送打开");
    }
}

-(void)layoutViews{
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@-49);
    }];
}

-(void)setupRightNavightionBtn{
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"home_icon_share"] forState:UIControlStateNormal];
    [shareBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [shareBtn addTarget:self action:@selector(pressToShareTheQND) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * myItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    [self.tabBarController.navigationItem setRightBarButtonItem:myItem];
}

-(UIView*)setupFootView{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 30)];
    footView.backgroundColor = [UIColor whiteColor];
    
    _announceView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, ViewWidth, 20)];
    _announceView.backgroundColor = [UIColor clearColor];
    [footView addSubview:_announceView];
    
    UILabel * leftLabel = [[UILabel alloc]init];
    [leftLabel setFrame:CGRectMake(20, 0, 42, 20)];
    leftLabel.font = QNDFont(12.0);
    leftLabel.textColor = QNDRGBColor(60, 111, 231);
    NSString * str = @"公告 | ";
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(12);
    attrs[NSForegroundColorAttributeName] = black74TitleColor;
    
    NSRange rang1 = [str rangeOfString:@"|"];
    [attrStr addAttributes:attrs range:rang1];
    
    leftLabel.attributedText = attrStr;
    [_announceView addSubview:leftLabel];
    
    _announceLabel = [[WHAnnouncementLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel.frame), 2, ViewWidth-24-70, 20)];
    _announceLabel.font = QNDFont(12.0);
    _announceLabel.textColor = black74TitleColor;
    _announceLabel.speed = 0.2;
    _announceLabel.text = _announceStr;
    [_announceView addSubview:_announceLabel];
    //根据长度判断
    if (_announceStr.length>1) {
        [_announceLabel startAnimation];
    }else{
        [_announceLabel stopAnimation];
    }
    _announceView.hidden = _announceStr.length > 0 ? NO : YES;
    
    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  showTheList ? 2 : 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1&&showTheList) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 30;
    }else{
        return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return [self setupFootView];
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return showTheList ? 177 : 180;
    }else if (indexPath.section==1){
        return showTheList ? 157 : 230;
    }else{
        return 70;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.section==0) {
        if (showTheList) {
            [self.smallCell setAmount:totalAmount];
            return self.smallCell;
        }else{
            [self.bannerCell setDataArray:self.QNDBannerArray];
            @WHWeakObj(self);
            [self.bannerCell setBblcok:^(NSString *pid, NSString *name) {
                WangWebViewController * webVC = [[WangWebViewController alloc]init];
                webVC.url= pid;
                webVC.webType = name;
                [Weakself.navigationController pushViewController:webVC animated:YES];
            }];
            return self.bannerCell;
        }
    }else if (indexPath.section==1){
        if (showTheList) {
            self.CPLCell = [tableView dequeueReusableCellWithIdentifier:@"CPLCell"];
            CPLProductModel * model = self.dataArray[indexPath.row];
            if (model) {
                [self.CPLCell setModel:model];
            }
            return self.CPLCell;
        }else{
         return self.midCell;
        }
    }else{
        @WHWeakObj(self);
        [self.btnCell setBlock:^{
            //需要判断跳转情况
            [Weakself judeToJump];
        }];
        return self.btnCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (showTheList&&indexPath.section==1) {
        CPLProductModel * model = self.dataArray[indexPath.row];
        CPLProductDetailViewController * detailVC = [[CPLProductDetailViewController alloc]init];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark- 数据请求
-(void)setupDataInfo{
    if (self.QNDBannerArray.count>0) {
        [self.QNDBannerArray removeAllObjects];
    }
    QNDNewHomePageBannerApi * bannerApi = [[QNDNewHomePageBannerApi alloc]init];
    [bannerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            NSDictionary * dataDic = [request responseJSONObject][@"data"];
            NSArray * bannerArr = dataDic[@"bannerInfo"];
            for (NSDictionary * dic in bannerArr) {
                bannerModel * model = [[bannerModel alloc]initWithDictionary:dic];
                [self.QNDBannerArray addObject:model];
            }
            _announceStr = [dataDic[@"notice"] firstObject][@"noticeContent"];
            
        }else{
            [self.view makeToast:[request responseJSONObject][@"msg"]];
        }
        [self.MainTable reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
    if (showTheList) {
        //请求列表
        [self setupListData];
    }
}

-(void)setupListData{
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    QNDCPLProListApi * qndApi = [[QNDCPLProListApi alloc]init];
    CPLProductListApi * cplApi = [[CPLProductListApi alloc]init];
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    [chain addRequest:qndApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        WHLog(@"%@",baseRequest.responseJSONObject);
        NSInteger status = [[baseRequest responseJSONObject][@"status"] integerValue];
        if (status==1) {
            NSArray * dataArr = [baseRequest responseJSONObject][@"data"];
            for (NSDictionary * dic in dataArr) {
                CPLProductModel * model = [[CPLProductModel alloc]initWithDictionary:dic];
                model.isQND = YES;
                [self.dataArray addObject:model];
            }
        }else if(status==-1){
            [[WHTool shareInstance]GoToLoginWithFromVC:self];
            return;
        }else{[self.view makeCenterToast:[baseRequest responseJSONObject][@"msg"]];}

        [chainRequest addRequest:cplApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            WHLog(@"%@",baseRequest.responseJSONObject);
            NSArray * sourceArr = [baseRequest responseJSONObject][@"data"];
            for (NSDictionary * dic in sourceArr) {
                CPLProductModel * model = [[CPLProductModel alloc]initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }];
    }];
    chain.delegate = self;
    [chain start];
}

-(void)chainRequestFinished:(YTKChainRequest *)chainRequest{
    //计算总额度
    totalAmount = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (CPLProductModel * model in self.dataArray) {
            totalAmount += model.max_amount;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.MainTable reloadData];
        });
    });
    
}

-(void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request{
    
}

//判断用户是否完善过信息
-(void)setupTheCPLUserInfo{
    CPLUserCreditsListApi * api = [[CPLUserCreditsListApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        WHLog(@"%@",request.responseJSONObject);
        NSDictionary * sourceDic = [request responseJSONObject];
        if ([sourceDic[@"status_code"] integerValue] == 403) {
            //CPLToken过期，自动重新获取token
            [self setupTheCPLToken];
            return ;
        }
        NSArray * sourceArr = [request responseJSONObject][@"data"];
        if ([sourceArr isKindOfClass:[[NSNull null] class]]) {
            //数据有误，或用户没有完善信息，显示完善信息页面
            showTheList = NO;
            [self setupDataInfo];
            return;
        }
        for (NSDictionary * dic in sourceArr) {
            CPLCreditListModel * model = [[CPLCreditListModel alloc]initWithDictionary:dic];
            //判断基础信息是否已经认证
            if ([model.credit_code isEqualToString:@"basic"]) {
                if (model.credit_status == 2) {
                    //用户已经完善过信息，显示产品列表
                    showTheList = YES;
                    [self setupDataInfo];
                }else{
                    //用户没有完善信息，显示完善信息页面
                    showTheList = NO;
                    [self setupDataInfo];
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [[WHLoading ShareInstance]hidenHud];
    }];
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
        [self setupTheCPLUserInfo];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [[WHLoading ShareInstance]hidenHud];
    }];
}

-(void)judgeToShowTheProList{
    //判断可以显示列表
    if (KGetACCESSTOKEN) {
        if (KGetCPLTOKEN) {
            [self setupTheCPLUserInfo];//请求判断用户是否已经完善信息
        }else{
           [self setupTheCPLToken];//自动请求新的CPLtoken
        }
    }else{
        showTheList = NO;
        [self setupDataInfo];
    }
}
#pragma mark-完善信息的按钮
-(void)judeToJump{
    if (KGetACCESSTOKEN) {
        //跳转到完善信息页面
        CPLBasicCreditViewController * basicVC = [[CPLBasicCreditViewController alloc]init];
        [self.navigationController pushViewController:basicVC animated:YES];

    }else{
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
        return;
    }
}

#pragma mark-定位相关delegate
//定位中
- (void)locating {
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    //将位置上传至后台
    WHLog(@"%@",locationDictionary);
    NSString * State = [locationDictionary valueForKey:@"State"];//省
    NSString *city = [locationDictionary valueForKey:@"City"];//市
    NSString * subLocality = [locationDictionary valueForKey:@"SubLocality"];//区
    if (!State) {
        State = city;
    }
    NSString * locationStr = FORMAT(@"%@/%@/%@",State,city,subLocality);
    [self sendTheLocationWithLocationStr:locationStr];
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    WHLog(@"%@",message);
    @WHWeakObj(self);
    [[WHTool shareInstance]showAlterViewWithTitle:@"请打开定位功能" Message:message cancelBtn:@"不获取新口子" doneBtn:@"获取最新口子"andVC:self andDoneBlock:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
            [[UIApplication sharedApplication] openURL:settingUrl];
        }
    } andCancelBlock:^(UIAlertAction * _Nonnull action) {
        [Weakself.navigationController popToRootViewControllerAnimated:YES];
    }];
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    WHLog(@"%@",message);
}

-(void)sendTheLocationWithLocationStr:(NSString*)locationStr{
    QNDLocationPostApi * api = [[QNDLocationPostApi alloc]initWithLocationString:locationStr];
    [[WHTool shareInstance] GetDataFromApi:api andCallBcak:^(NSDictionary *dic) {
    }];
}


#pragma mark- 分享去哪贷
-(void)pressToShareTheQND{
    //分享去哪贷
    [TalkingData trackEvent:@"分享按钮" label:@"分享按钮"];
    [WHShareView initWithTitle:@"去哪贷-贷款就上去哪贷" Message:@"让贷款不再难,专业的贷款需求匹配平台" andThumbImage:@"ico"];
    [TalkingData trackEvent:@"分享去哪贷" label:@"分享去哪贷"];
}

-(bannerTableViewCell*)bannerCell{
    if (!_bannerCell) {
        _bannerCell = [[bannerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bannerCell"];
    }
    return _bannerCell;
}

-(QNDNewHPMidTableViewCell*)midCell{
    if (!_midCell) {
        _midCell = [[QNDNewHPMidTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"midCell"];
    }
    return _midCell;
}

-(QNDBottomBtnTableViewCell*)btnCell{
    if (!_btnCell) {
        _btnCell = [[QNDBottomBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"btnCell"];
    }
    return _btnCell;
}

-(QNDSamllCardTableViewCell *)smallCell{
    if (!_smallCell) {
        _smallCell = [[QNDSamllCardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"small"];
    }
    return _smallCell;
}

-(CPLProductListTableViewCell *)CPLCell{
    if (!_CPLCell) {
        _CPLCell = [[CPLProductListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLCell"];
    }
    return _CPLCell;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

-(NSMutableArray*)QNDBannerArray{
    if (!_QNDBannerArray) {
        _QNDBannerArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _QNDBannerArray;
}

@end
