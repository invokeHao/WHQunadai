//
//  QNDAddBankViewController.m
//  qunadai
//
//  Created by wang on 2017/9/26.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDAddBankViewController.h"
#import "QNDBankListTableViewController.h"

#import "BankRequirementModel.h"

#import "requirementApi.h"
#import "requirementPostApi.h"

#import "WHVerify.h"

@interface QNDAddBankViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView * MainTable;

@property (strong,nonatomic) UITextField * NameField;

@property (strong,nonatomic) UITextField * bankCDNumField;

@property (strong,nonatomic) UITextField * userCDNumField;

@property (strong,nonatomic) UITextField * userphoneNumField;
@end

@implementation QNDAddBankViewController
{
    NSMutableDictionary * attrs;//placeHold的字体
    BankRequirementModel * model;
    NSArray * titleArray;
    UILabel * detailLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupData];
    self.title = @"银行卡";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)layoutViews{
    titleArray = @[@"持卡人姓名",@"身份证号码",@"银行卡卡号",@"预留手机号",@"开卡银行"];
    attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(15.0);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    //滚动时收起键盘
    _MainTable.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
-(UIView*)createFootview{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 86)];
    footView.backgroundColor = [UIColor clearColor];

    UIButton * postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setTitle:@"确认" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postBtn setBackgroundColor:ThemeColor];
    [postBtn.titleLabel setFont:QNDFont(18.0)];
    postBtn.layer.cornerRadius = 2;
    postBtn.clipsToBounds = YES;
    [postBtn addTarget:self action:@selector(pressToSaveTheBankCard) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:postBtn];
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.bottom.equalTo(@-10);
        make.height.equalTo(@46);
    }];
    return footView;
}

#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 86;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [self createFootview];
    return  footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bankTextcell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = QNDFont(14.0);
    titleLabel.textColor = black31TitleColor;
    titleLabel.text = titleArray[indexPath.row];
    [cell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell);
        make.left.equalTo(@12);
        make.height.equalTo(@15);
    }];
    if (indexPath.row==0) {
         [self layoutField:self.NameField OnCell:cell];
    }else if (indexPath.row==1){
        [self layoutField:self.userCDNumField OnCell:cell];
    }else if (indexPath.row==2){
        [self layoutField:self.bankCDNumField OnCell:cell];
    }else if (indexPath.row==3){
        [self layoutField:self.userphoneNumField OnCell:cell];
    }else{
        detailLabel = [[UILabel alloc]init];
        detailLabel.font = QNDFont(16.0);
        detailLabel.textColor = QNDRGBColor(153, 153, 153);
        detailLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-12);
            make.centerY.mas_equalTo(cell);
            make.height.equalTo(@17);
        }];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)layoutField:(UITextField*)text OnCell:(UITableViewCell*)cell{
    [cell.contentView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(cell.contentView);
    }];
}

-(UITextField *)NameField{
    if (!_NameField) {
        _NameField = [[UITextField alloc]init];
        _NameField.font =QNDFont(16.0);
        _NameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"持卡人姓名" attributes:attrs];
        _NameField.textAlignment = NSTextAlignmentRight;
        _NameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _NameField.tintColor = ThemeColor;
        _NameField.textColor = QNDRGBColor(153, 153, 153);
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
        _userCDNumField.font =QNDFont(16.0);
        _userCDNumField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"持卡人身份证" attributes:attrs];
        _userCDNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userCDNumField.textAlignment = NSTextAlignmentRight;
        _userCDNumField.tintColor = ThemeColor;
        _userCDNumField.textColor = QNDRGBColor(153, 153, 153);
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
    textField.textAlignment = NSTextAlignmentRight;
    textField.tintColor = ThemeColor;
    textField.font = QNDFont(16.0);
    textField.textColor = QNDRGBColor(153, 153, 153);
    return textField;
}
#pragma mark-网络请求

-(void)setupData{
    [[WHLoading ShareInstance] showImageHUD:self.view];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    WHLog(@"%@",[user objectForKey:KUserToken]);
    requirementApi * api = [[requirementApi alloc]initWithToken:[user objectForKey:KUserToken]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary *  requirementDic = [request responseJSONObject][@"content"][@"requirement"];
        if (![requirementDic isKindOfClass:[NSNull class]]) {
            model = [[BankRequirementModel alloc]initWithDictionary:requirementDic];
            [self setdata];
        }
        WHLog(@"%@",requirementDic);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        WHLog(@"error==%@",request.error);
    }];
}

-(void)setdata{
    self.NameField.text = model.name;
    self.bankCDNumField.text = model.bankCardNumber;
    self.userCDNumField.text = model.idNumber;
    self.userphoneNumField.text = model.mobileNumber;
    detailLabel.text = @"建设银行";
}
#pragma mark- 保存银行卡信息
-(void)pressToSaveTheBankCard{
    [self.view endEditing:YES];
    if (![self checkTheInfo]) {
        return;
    }
    [[WHLoading ShareInstance]showImageHUD:self.view];
    requirementPostApi * api = [[requirementPostApi alloc]initName:_NameField.text andBankNum:_bankCDNumField.text andMobileNum:_userphoneNumField.text andIdNum:_userCDNumField.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        QNDBankListTableViewController * bankListVC = [[QNDBankListTableViewController alloc]init];
        bankListVC.bankNum = self.bankCDNumField.text;
        bankListVC.bankName = detailLabel.text;
        [self.navigationController pushViewController:bankListVC animated:YES];
        WHLog(@"%@",[request responseJSONObject]);
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
