//
//  QNDMineHPViewController.m
//  qunadai
//
//  Created by wang on 2017/9/8.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDMineHPViewController.h"
#import "MineSettingViewController.h"
#import "AccountViewController.h"
#import "QNDLoginViewController.h"
#import "QNDLoanHistoryViewController.h"
#import "QNDAddBankViewController.h"
#import "QNDFeedbackViewController.h"
#import "CPLProTypeViewController.h"
#import "WHJSWebViewController.h"

#import "WHShareView.h"
#import "MineFunctionTableViewCell.h"
#import "MineInfoTableViewCell.h"


#import "QNDUserCountInfoApi.h"
#import "AccountModel.h"
#import "QNDFuDataOperatorApi.h"


@interface QNDMineHPViewController ()<UITableViewDelegate,UITableViewDataSource,YTKChainRequestDelegate>
{
    NSArray * titleArray;
    NSArray * iconArray;
    NSArray * detailArray;
    BOOL _haveNewMessage;
}

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)NSMutableArray * dataArray;

@property (strong,nonatomic)AccountModel * model;

@end

@implementation QNDMineHPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //接受通知
    NOTIF_ADD(KNOTIFICATION_SUCCESS, changeTheCellItem);
    NOTIF_ADD(KNOTIFICATION_APPLICATION, haveTheNewApplication:);
    [self setData];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.tabBarController.navigationItem setRightBarButtonItems:nil];
    self.tabBarController.title = @"我的";
    [self setupData];
    [TalkingData trackEvent:@"我的" label:@"我的"];
    [TalkingData trackPageBegin:@"我的页面访问时长"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"我的页面访问时长"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeTheCellItem{
    if (KWHSUCCESS) {
        return;
    }else{
        [self setData];
        [_MainTable reloadData];
    }
}

-(void)layoutViews{
    _MainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight-64-49) style:UITableViewStylePlain];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.tableFooterView = [self setupFootView];
    __weak id weakSelf = self;
    _MainTable.delegate = weakSelf;
    _MainTable.dataSource = weakSelf;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@-49);
    }];
    
    if (KIOS11Later) {
        self.MainTable.estimatedRowHeight = 0;
        self.MainTable.estimatedSectionHeaderHeight = 0;
        self.MainTable.estimatedSectionFooterHeight = 0;    }
}

-(UIView*)setupFootView{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 90)];
    backView.backgroundColor = [UIColor clearColor];
    
    UILabel * phoneLabel = [[UILabel alloc]init];
    phoneLabel.font = QNDFont(12.0);
    phoneLabel.textColor = QNDRGBColor(153, 153, 153);
    NSString * customerServiceHotline = [[NSUserDefaults standardUserDefaults] objectForKey:KCustomerServiceHotline];
    phoneLabel.text = FORMAT(@"电      话：%@",customerServiceHotline);
    [backView addSubview:phoneLabel];
    
    UILabel * emailLabel = [[UILabel alloc]init];
    emailLabel.font = QNDFont(12.0);
    emailLabel.textColor = QNDRGBColor(153, 153, 153);
    NSString * bussContactStr = [[NSUserDefaults standardUserDefaults] objectForKey:KBussContact];
    emailLabel.text = FORMAT(@"商务联系：%@",bussContactStr);
    [backView addSubview:emailLabel];
    //布局
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView);
        make.top.equalTo(@40);
        make.size.mas_equalTo(CGSizeMake(200, 13));
    }];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(phoneLabel);
        make.top.mas_equalTo(phoneLabel.mas_bottom).with.offset(7);
        make.size.mas_equalTo(CGSizeMake(200, 13));
    }];
    
    return backView;
}

#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (KWHSUCCESS) {
        return 2;
    }
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section ==1){
        if (KWHSUCCESS) {
            return 4;
        }else{
            return 1;
        }
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 150;
    }else{
        return 49;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        MineInfoTableViewCell * infoCell = [[MineInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineInfoCell"];
        if (!_model) {
            [infoCell.nameLabel setText:@"请点击登录"];
            [infoCell.avatarBtn setImage:[UIImage imageNamed:@"head_boy"] forState:UIControlStateNormal];
        }else{
            [infoCell setModel:_model];
        }
        @WHWeakObj(self);
        [infoCell setUserB:^{
            if (!KGetACCESSTOKEN) {
                [[WHTool shareInstance]GoToLoginWithFromVC:self];
                return;
            }
            AccountViewController * accountVC = [[AccountViewController alloc]init];
            [Weakself.navigationController pushViewController:accountVC animated:YES];
        }];
        [infoCell setValueB:^{
            //我的信息
            if (!KGetACCESSTOKEN) {
                [[WHTool shareInstance]GoToLoginWithFromVC:self];
                return ;
            }
            //跳转认证运营商
            [Weakself getTheFuDataUrl];
        }];

        return infoCell;
    }else{
        MineFunctionTableViewCell * functionCell = [[MineFunctionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineFunctionCell"];
        if (KWHSUCCESS) {
            functionCell.titleLabel.text = titleArray[indexPath.row];
            functionCell.iconView.image = [UIImage imageNamed:iconArray[indexPath.row]];
        }else {
            functionCell.titleLabel.text = titleArray[indexPath.row+(indexPath.section-1)];
            functionCell.iconView.image = [UIImage imageNamed:iconArray[indexPath.row+(indexPath.section-1)]];
        }
        if (indexPath.section==1&&indexPath.row==0) {
            functionCell.redPoint.hidden = _haveNewMessage ? NO : YES;
        }
        return functionCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (KWHSUCCESS) {
        if (indexPath.section==0) {
            
        }else if (indexPath.section ==1){
            if (indexPath.row==0) {
                if (!KGetACCESSTOKEN) {
                    [[WHTool shareInstance]GoToLoginWithFromVC:self];
                    return;
                }
                QNDAddBankViewController * addBankVC = [[QNDAddBankViewController alloc]init];
                [self.navigationController pushViewController:addBankVC animated:YES];
            }else if (indexPath.row==1){
                //借款记录
                if (!KGetACCESSTOKEN) {
                    [[WHTool shareInstance]GoToLoginWithFromVC:self];
                    return;
                }
                QNDLoanHistoryViewController * loanHisVC = [[QNDLoanHistoryViewController alloc]init];
                [self.navigationController pushViewController:loanHisVC animated:YES];
            }else if (indexPath.row ==2){
                if (!KGetACCESSTOKEN) {
                    [[WHTool shareInstance]GoToLoginWithFromVC:self];
                    return;
                }
                QNDFeedbackViewController * feedbackVC = [[QNDFeedbackViewController alloc]init];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }else if(indexPath.row==3){
                MineSettingViewController * settingVC = [[MineSettingViewController alloc]init];
                [self.navigationController pushViewController:settingVC animated:YES];
            }
        }
    }
    else{
        if (indexPath.section==0&&indexPath.row ==0) {
            
        }else if (indexPath.section==1&&indexPath.row==0){
            //专区申请记录
            if (!KGetACCESSTOKEN) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KCPLLOGIN];
                [[WHTool shareInstance]GoToLoginWithFromVC:self];
                return;
            }
            CPLProTypeViewController * typeVC = [[CPLProTypeViewController alloc]init];
            [self.navigationController pushViewController:typeVC animated:YES];

        }else if (indexPath.section==2&&indexPath.row==0){
            //意见反馈
            if (!KGetACCESSTOKEN) {
                [[WHTool shareInstance]GoToLoginWithFromVC:self];
                return;
            }
            QNDFeedbackViewController * feedbackVC = [[QNDFeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }else if (indexPath.section==2&&indexPath.row==1){
            //分享去哪贷
            [TalkingData trackEvent:@"分享按钮" label:@"分享按钮"];
            [WHShareView initWithTitle:@"去哪贷-贷款就上去哪贷" Message:@"让贷款不再难,专业的贷款需求匹配平台" andThumbImage:@"ico"];
            [TalkingData trackEvent:@"分享去哪贷" label:@"分享去哪贷"];

        }else if(indexPath.section==2&&indexPath.row==2){
            //设置
            MineSettingViewController * settingVC = [[MineSettingViewController alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    }
}

-(void)setData{
    if (KWHSUCCESS) {
        titleArray = @[@"银行卡",@"借款记录",@"意见反馈",@"设置"];
        iconArray = @[@"content_icon_view",@"icon_calendar",@"me_icon_leave_mes",@"me_icon_set"];
    }else{
        iconArray = @[@"me_icon_application",@"me_icon_leave_mes",@"me_icon_share",@"me_icon_set"];
        titleArray = @[@"申请记录",@"意见反馈",@"分享去哪贷",@"设置"];
    }
}

-(void)setupData{
    NSString * phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPhoneNum];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:KUserToken]||!phoneNum) {
        self.model = nil;
        [self.MainTable reloadData];
        return;
    }
    QNDUserCountInfoApi * api = [[QNDUserCountInfoApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        [[WHLoading ShareInstance]hidenHud];
        [[WHOopsView shareInstance]hidenTheOops];
        NSDictionary * dataDic = [request responseJSONObject][@"data"];
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            _model = [[AccountModel alloc]initWithDictionary:dataDic];
        }else if(status==-1){
            [[WHTool shareInstance]GoToLoginWithFromVC:self];
            return;
        }else{[self.view makeCenterToast:[request responseJSONObject][@"msg"]];}
        [self.MainTable reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseStatusCode==0) {
            [[WHLoading ShareInstance]hidenHud];
            @WHWeakObj(self);
            [[WHOopsView shareInstance]showTheOopsViewOneTheView:self.view WithDoneBlock:^{
                [Weakself setupData];
            }];
        }
    }];
}

-(void)getTheFuDataUrl{
    QNDFuDataOperatorApi * api = [[QNDFuDataOperatorApi alloc]init];
    [[WHTool shareInstance]GetDataFromApi:api andCallBcak:^(NSDictionary *dic) {
        [TalkingData trackEvent:@"手机信用点击" label:@"手机信用点击"];
        WHJSWebViewController * jsWebVC = [[WHJSWebViewController alloc]init];
        jsWebVC.titleName = @"运营商认证";
        NSString * url = dic[@"accessUrl"];
        if ([url isKindOfClass:[[NSNull null] class]]) {
            return ;
        }
        jsWebVC.Url = dic[@"accessUrl"];
        [self.navigationController pushViewController:jsWebVC animated:YES];
    }];
}

-(void)haveTheNewApplication:(NSNotification*)notification{
    BOOL haveNewMessage = [[notification object] boolValue];
    _haveNewMessage = haveNewMessage;
    [self.MainTable reloadData];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


@end
