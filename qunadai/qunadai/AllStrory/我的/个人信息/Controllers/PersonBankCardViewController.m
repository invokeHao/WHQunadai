//
//  PersonBankCardViewController.m
//  qunadai
//
//  Created by wang on 17/4/7.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "PersonBankCardViewController.h"
#import "ControlAllNavigationViewController.h"
#import "wangTabBarController.h"
#import "AppDelegate.h"

#import "YellowAlertTableViewCell.h"
#import "VerifyBottomTableViewCell.h"
#import "InfoProgressiView.h"
#import "WangWebViewController.h"

#import "requirementApi.h"
#import "requirementPostApi.h"
#import "BankRequirementModel.h"

#import "WHVerify.h"


@interface PersonBankCardViewController ()
{
    NSMutableDictionary * attrs;//placeHold的字体
    BOOL hasDelete;
    BankRequirementModel * model;
}

@property (strong,nonatomic) UITableView * MainTable;

@property (strong,nonatomic) UITextField * NameField;

@property (strong,nonatomic) UITextField * bankCDNumField;

@property (strong,nonatomic) UITextField * userCDNumField;

@property (strong,nonatomic) UITextField * userphoneNumField;

@property (assign,nonatomic) int sectionNum;

@end

@interface PersonBankCardViewController ()

@end

@implementation PersonBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"身份认证";
    [self setupData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"四要素页面"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    _sectionNum = 1;
    attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(15.0);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    __weak id weakSelf = self;
    _MainTable.delegate = weakSelf;
    _MainTable.dataSource = weakSelf;
    //滚动时收起键盘
    _MainTable.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

-(UIView*)createHeaderView{
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 80)];
    CGRect headerRect = CGRectMake(0, 0, ViewWidth, 80);
    InfoProgressiView * progress = [[InfoProgressiView alloc]initWithFinishColor:ThemeColor andFrame:headerRect andTitle:@"0"];
    [header addSubview:progress];

    return header;
}


#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return hasDelete ? 3 : 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==_sectionNum||section==_sectionNum+1 ? 2 : 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==_sectionNum ? 80 : 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section==_sectionNum ? [self createHeaderView] : nil ;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (hasDelete) {
        return 10;
    }else{
        if (section==0) {
            return 0;
        }else{
            return 10;
        }
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (hasDelete) {
        if (indexPath.section==0||indexPath.section==1) {
            return 50;
        }else{
            return 80;
        }
    }else{
        if (indexPath.section==0) {
            return 32;
        }else if (indexPath.section==1||indexPath.section==2){
            return 50;
        }else{
            return 80;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bankTextcell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    __strong typeof(self)strongSelf = weakSelf;
    if (indexPath.section==0&&!hasDelete) {
        YellowAlertTableViewCell * yellowCell = [[YellowAlertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yellowAlertCell"];
        [yellowCell setYellowBlock:^{
            //删除提示cell
            _sectionNum = 0;
            hasDelete = YES;
            [strongSelf.MainTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [strongSelf.MainTable performSelector:@selector(reloadData) withObject:nil afterDelay:0.5f];
        }];
        return yellowCell;
    }else if (indexPath.section==_sectionNum){
        if (indexPath.row==0) {
            [self layoutField:self.NameField OnCell:cell];
        }else{
            [self layoutField:self.bankCDNumField OnCell:cell];
        }
    }else if (indexPath.section==_sectionNum+1){
        if (indexPath.row==0) {
            [self layoutField:self.userCDNumField OnCell:cell];
        }else{
            [self layoutField:self.userphoneNumField OnCell:cell];
        }
    }else{
        //特殊化处理的view
        VerifyBottomTableViewCell * verifyCell = [[VerifyBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VerifyBottomTableViewCell"];
        [verifyCell setVBlcok:^{
            [weakSelf verifyTheBankInfo];
        }];
        [verifyCell setRBlock:^{
            WangWebViewController * wangWebVC = [[WangWebViewController alloc]init];
            wangWebVC.webType = @"征信查询授权书";
            wangWebVC.url = @"https://hft.qunadai.com/resources/yinsiquan.html";
            [weakSelf.navigationController pushViewController:wangWebVC animated:YES];
        }];
        return verifyCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)layoutField:(UITextField*)text OnCell:(UITableViewCell*)cell{
    [cell.contentView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.centerY.mas_equalTo(cell.contentView);
    }];
}

-(UITextField *)NameField{
    if (!_NameField) {
        _NameField = [[UITextField alloc]init];
        _NameField.font =QNDFont(15.0);
        _NameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"持卡人姓名" attributes:attrs];
        _NameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _NameField.tintColor = ThemeColor;
    }
    return _NameField;
}

-(UITextField *)bankCDNumField{
    if (!_bankCDNumField) {
        _bankCDNumField = [self createTextFieldWithPlaceholder:@"银行卡卡号"];
    }
    return _bankCDNumField;
}

-(UITextField *)userCDNumField{
    if (!_userCDNumField) {
        _userCDNumField = [[UITextField alloc]init];
        _userCDNumField.font =QNDFont(15.0);
        _userCDNumField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"持卡人身份证" attributes:attrs];
        _userCDNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userCDNumField.tintColor = ThemeColor;
    }
    return _userCDNumField;
}

-(UITextField *)userphoneNumField{
    if (!_userphoneNumField) {
        _userphoneNumField = [self createTextFieldWithPlaceholder:@"银行预留手机号"];
    }
    return _userphoneNumField;
}

-(UITextField  *)createTextFieldWithPlaceholder:(NSString*)placehodler{
    UITextField * textField = [[UITextField alloc]init];
    textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placehodler attributes:attrs];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.tintColor = ThemeColor;
    textField.font = QNDFont(15.0);
    return textField;
}

-(void)setdata{
    self.NameField.text = model.name;
    self.bankCDNumField.text = model.bankCardNumber;
    self.userCDNumField.text = model.idNumber;
    self.userphoneNumField.text = model.mobileNumber;
}
#pragma mark-网络请求

-(void)setupData{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    requirementApi * api = [[requirementApi alloc]initWithToken:[user objectForKey:KUserToken]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary *  requirementDic = [request responseJSONObject][@"content"][@"requirement"];
        if (![requirementDic isKindOfClass:[NSNull class]]) {
            model = [[BankRequirementModel alloc]initWithDictionary:requirementDic];
            [self setdata];
        }
        WHLog(@"%@",model);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
    }];
}

#pragma mark-验证信息

-(void)verifyTheBankInfo{
    if (![self checkTheInfo]) {
        return;
    }
    [[WHLoading ShareInstance]showImageHUD:self.view];
    requirementPostApi * api = [[requirementPostApi alloc]initName:_NameField.text andBankNum:_bankCDNumField.text andMobileNum:_userphoneNumField.text andIdNum:_userCDNumField.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",[request responseJSONObject]);
        [[WHLoading ShareInstance]hidenHud];
        //跳转到额度首页
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        wangTabBarController * wangTabVC = [[wangTabBarController alloc]init];
        wangTabVC.selectedIndex = 1;
        ControlAllNavigationViewController*allNavVC = [[ControlAllNavigationViewController alloc]initWithRootViewController:wangTabVC];
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = allNavVC;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [[WHLoading ShareInstance]hidenHud];
        [self.view makeToast:[request responseJSONObject][@"detail"]];
    }];
}


#pragma mark-校验信息格式

-(BOOL)checkTheInfo{
    BOOL phone = [WHVerify checkTelNumber:_userphoneNumField.text];
    BOOL idNum = [WHVerify checkUserIdCard:_userCDNumField.text];
    BOOL BankNum = [WHVerify checkBankNum:_bankCDNumField.text];
    BOOL name = [WHVerify checkUserName:_NameField.text];
    if (phone&&idNum&&BankNum&&name) {
        return YES;
    }else{
        if (!name) {
            [self.view makeCenterToast:@"请输入正确的姓名"];
        }else if (!BankNum){
            [self.view makeCenterToast:@"请输入正确的银行卡号"];
        }else if (!idNum){
            [self.view makeCenterToast:@"请输入正确的身份证号"];
        }else if (!phone){
            [self.view makeCenterToast:@"输入手机号与登录手机号不匹配"];
        }
        return NO;
    }
}


@end
