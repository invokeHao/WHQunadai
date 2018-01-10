//
//  PersonalInfoViewController.m
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonBankCardViewController.h"
#import "ControlAllNavigationViewController.h"
#import "wangTabBarController.h"
#import "AppDelegate.h"

#import "YellowAlertTableViewCell.h"
#import "WHTablePickerVIew.h"

#import "InfoProgressiView.h"
#import "WHCityPicker.h"

#import "userDetailInfoApi.h"
#import "userDetailInfoPostApi.h"
#import "PensonVerifyStatusApi.h"

#import "userDetailInfoModel.h"
#import "personVerifyStatusModel.h"


#define KTextFieldWidth 150

@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YTKChainRequestDelegate>
{
    NSArray * titleArray;
    BOOL hasDelete;
    BOOL hasNextStep;//是否需要跳转下一步
    UIButton * verifyBtn ;
    NSMutableArray * infoArray;
}
@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)NSMutableArray * dataArray;

@property (strong,nonatomic)UITextField * loanText;//借款额度

@property (strong,nonatomic)UITextField * incomeText;//收入

@property (strong,nonatomic)userDetailInfoModel * model;

@property (assign,nonatomic)int sectionNum;


@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self layoutViews];
    NOTIF_ADD(UITextFieldTextDidChangeNotification, textFieldDidChanged:);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //状态栏恢复默认设置
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"真实信息";
    [self setupData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"真是信息页面"];
}

-(void)dealloc{
    @try {
        [self removeObserver:self forKeyPath:UITextFieldTextDidChangeNotification];
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setData{
    _sectionNum = 1;
    NSArray *arr0 =@[@""];
    NSArray * arr3 = @[@""];

    titleArray=@[@"借款额度",@"借款期限",@"职业情况",@"家庭收入",@"教育程度",@"婚姻情况",@"常居住地"];
    NSArray * loandate = @[@"7天",@"15天",@"1月",@"3月",@"5月",@"7月",@"9月",@"12月",@"18月",@"24月",@"36月"];
    NSArray * workData = @[@"上班族",@"学生",@"无固定职业"];
    NSArray * education = @[@"博士及以上",@"硕士",@"大学本科",@"高中或中专",@"初中",@"其他"];
    NSArray * arr = @[@"已婚",@"未婚",@"离异",@"其他"];
    _dataArray= [NSMutableArray arrayWithCapacity:0];
    [_dataArray addObject:arr0];
    [_dataArray addObject:loandate];
    [_dataArray addObject:workData];
    [_dataArray addObject:arr3];
    [_dataArray addObject:education];
    [_dataArray addObject:arr];
    
}

-(void)layoutViews{
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    __weak id weakSelf = self;
    _MainTable.delegate = weakSelf;
    _MainTable.dataSource = weakSelf;
    [self.view addSubview:_MainTable];
    _MainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

-(UIView*)createHeaderView{
    NSString * str =  hasNextStep  ? @"1" : @"10";
    UIColor * color = hasNextStep ? defaultGrayBackGroundColor : ThemeColor;
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 80)];
    CGRect headerRect = CGRectMake(0, 0, ViewWidth, 80);
    InfoProgressiView * progress = [[InfoProgressiView alloc]initWithFinishColor:color andFrame:headerRect andTitle:str];
    [header addSubview:progress];
    
    return header;
}


#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return hasDelete ?  2 : 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==_sectionNum ? titleArray.count : 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==_sectionNum ? 80 : 0 ;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section==_sectionNum ? [self createHeaderView] : nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return hasDelete ? 45 : 32;
    }else if (indexPath.section==1){
        return hasDelete ? 40 : 45;
    }else{
        return 40;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"realInfoCell"];
    
    __weak typeof(self) weakSelf =self;
    __strong typeof(self) strongSelf = weakSelf;
    cell.textLabel.font= QNDFont(15.0);
    cell.textLabel.textColor = blackTitleColor;
    cell.detailTextLabel.font = QNDFont(15.0);
    cell.detailTextLabel.text = @"请选择";
    if ([cell.detailTextLabel.text isEqualToString:@"请选择"]) {
        cell.detailTextLabel.textColor = defaultPlaceHolderColor;
    }else{
        cell.detailTextLabel.textColor = blackTitleColor;
    }
    
    UIImageView * moreView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 6)];
    [moreView setImage:[UIImage imageNamed:@"xiajiantou"]];
    cell.accessoryView = moreView;
    if (indexPath.section==0&&!hasDelete) {
        //提示cell
        YellowAlertTableViewCell * yellowCell = [[YellowAlertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yellowCell"];
        yellowCell.alertLabel.text = @"恶意填写信息会对您的额度造成不良影响";
        [yellowCell setYellowBlock:^{
            hasDelete = YES;
            _sectionNum = 0;
            [strongSelf.MainTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [strongSelf.MainTable performSelector:@selector(reloadData) withObject:nil afterDelay:0.5f];
        }];
        return yellowCell;
    }else if (indexPath.section==_sectionNum){
        cell.textLabel.text = titleArray[indexPath.row];
        if (indexPath.row==0) {
            cell.detailTextLabel.hidden=cell.accessoryView.hidden =YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _loanText = [self createTextFieldWithPlaceholder:@"请输入借款额度"];
            [self layoutField:_loanText OnCell:cell];
            if (infoArray.count>0) {
                _loanText.text = self.model.loanAmount;
            }
        }else if (indexPath.row==3){
            cell.detailTextLabel.hidden=cell.accessoryView.hidden =YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _incomeText = [self createTextFieldWithPlaceholder:@"请输入家庭收入"];
            [self layoutField:_incomeText OnCell:cell];
            if (infoArray.count>0) {
                _incomeText.text = self.model.householdIncome;
            }
        }else{
            if (infoArray.count>0) {
                cell.detailTextLabel.textColor = blackTitleColor;
                cell.detailTextLabel.text = infoArray[indexPath.row];
            }
        }
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.hidden = YES;
        cell.accessoryView.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        //按钮
        verifyBtn =[self createVerifyBtn];
//        if (hasNextStep) {
            [verifyBtn setTitle:@"下一步" forState:UIControlStateNormal];
//        }else{
//            [verifyBtn setTitle:@"完成" forState:UIControlStateNormal];
//        }
        [cell addSubview:verifyBtn];
        [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@-0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@40);
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [_MainTable cellForRowAtIndexPath:indexPath];
    if (indexPath.section==_sectionNum) {
        if (indexPath.row==0||indexPath.row==3) {
        }else if (indexPath.row==6){
            __weak typeof(self) weakSelf = self;
            [WHCityPicker showPickerOnTheWindowAndSelecteBlcok:^(NSString *selectedStr) {
                weakSelf.model.habitualResidence = selectedStr;
                cell.detailTextLabel.text = selectedStr;
                cell.detailTextLabel.textColor = blackTitleColor;
            }];
        }else{
            [self.view endEditing:YES];
            [WHTablePickerView showPickTableWithSouceArr:_dataArray[indexPath.row] andSelectBlock:^(NSString *selectedStr,NSInteger index) {
                cell.detailTextLabel.text = selectedStr;
                cell.detailTextLabel.textColor = blackTitleColor;
                switch (indexPath.row) {
                    case 1:{
                        _model.loanDeadLine = selectedStr;
                    }break;
                    case 2:{
                        _model.employmentStatus = selectedStr;
                    }break;
                    case 4:{
                        _model.educationLevel = selectedStr;
                    }break;
                    case 5:{
                        _model.maritalStatus = selectedStr;
                    }break;
                    case 6:{
                        _model.habitualResidence = selectedStr;
                    }break;
                    default:
                        break;
                }
            }];
        }
    }
}

-(void)layoutField:(UITextField*)text OnCell:(UITableViewCell*)cell{
    [cell addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-13);
        make.centerY.mas_equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(KTextFieldWidth, 20));
    }];
}

-(UIButton *)createVerifyBtn{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:ThemeColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [btn addTarget:self action:@selector(verifyTheRealInfo:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UITextField *)createTextFieldWithPlaceholder:(NSString*)placeholder{
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(15.0);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    UITextField * textField = [[UITextField alloc]init];
    textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeholder attributes:attrs];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.tintColor = ThemeColor;
    textField.font = QNDFont(15.0);
    textField.textAlignment= NSTextAlignmentRight;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    
    UILabel * unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 15)];
    unitLabel.font = QNDFont(14.0);
    unitLabel.textColor = blackTitleColor;
    unitLabel.textAlignment = NSTextAlignmentRight;
    unitLabel.text = @" 元";
    [textField setRightView:unitLabel];

    return textField;
}


#define textFieldDelegate
-(void)textFieldDidChanged:(UITextField*)textField{
    if (_incomeText.text.length>7||_loanText.text.length>6) {
        [self.view makeCenterToast:@"输入的金额过大"];
        [self.view endEditing:YES];
    }
    if ([_loanText.text hasPrefix:@"0"]) {
        [self.view makeCenterToast:@"请输入正确的格式"];
        _loanText.text = @"";
    }
    if ([_incomeText.text hasPrefix:@"0"]) {
        [self.view makeCenterToast:@"请输入正确的格式"];
        _incomeText.text = @"";
    }
}


-(void)setInfoData{
    infoArray = [NSMutableArray arrayWithCapacity:0];
    [infoArray addObject:@""];
    if (self.model.loanDeadLine) {
        [infoArray addObject:self.model.loanDeadLine];
    }else{
        [infoArray addObject:@""];
    }
    if (self.model.employmentStatus) {
        [infoArray addObject:self.model.employmentStatus];
    }else{
        [infoArray addObject:@""];
    }
    [infoArray addObject:@""];

    if (self.model.educationLevel) {
        [infoArray addObject:self.model.educationLevel];
    }else{
        [infoArray addObject:@""];
    }

    if (self.model.maritalStatus) {
        [infoArray addObject:self.model.maritalStatus];
    }else{
        [infoArray addObject:@""];
    }
    if (self.model.habitualResidence) {
        [infoArray addObject:self.model.habitualResidence];
    }else{
        [infoArray addObject:@""];
    }
}

-(BOOL)configTheVerifyStatus:(NSString*)status{
    if ([status isEqualToString:@"PROCESSING"]) {
        return  NO;
    }else if ([status isEqualToString:@"SUCCESS"]||[status isEqualToString:@"HRISK"]||[status isEqualToString:@"MRISK"]||[status isEqualToString:@"LRISK"]){
        return  NO;
    }else if ([status isEqualToString:@"CREATED"]){
        return YES;
    }else {
        return YES;
    }
}

#pragma  mark-提交真实信息,下一步

-(void)verifyTheRealInfo:(UIButton*)button{
    
    self.model.loanAmount = _loanText.text;
    self.model.householdIncome = _incomeText.text;

    if (self.model.paramDic==nil) {
        [self.view makeCenterToast:@"请完善信息后提交"];
        return;
    }
    [[WHLoading ShareInstance]showImageHUD:self.view];
    userDetailInfoPostApi * api = [[userDetailInfoPostApi alloc]initWithparamDic:self.model.paramDic];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"提交成功");

        [[WHLoading ShareInstance]hidenHud];
//        if (hasNextStep) {
            PersonBankCardViewController * bankVC = [[PersonBankCardViewController alloc]init];
            [self.navigationController pushViewController:bankVC animated:YES];
//        }else{
//            //跳转到额度首页
//            [self.navigationController popToRootViewControllerAnimated:NO];
//            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:KHadVerifyInfo];
//
//            wangTabBarController * wangTabVC = [[wangTabBarController alloc]init];
//            wangTabVC.selectedIndex = 1;
//            ControlAllNavigationViewController*allNavVC = [[ControlAllNavigationViewController alloc]initWithRootViewController:wangTabVC];
//            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//            appDelegate.window.rootViewController = allNavVC;
//        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"failed==%@",[request responseJSONObject]);
        [[WHLoading ShareInstance]hidenHud];
    }];
}

-(void)setupData{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    userDetailInfoApi * api = [[userDetailInfoApi alloc]init];
    PensonVerifyStatusApi * verifyApi = [[PensonVerifyStatusApi alloc]init];
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    [chain addRequest:api callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSDictionary * dic = [baseRequest responseJSONObject][@"content"][@"userCreditInfo"];
        self.model = [[userDetailInfoModel alloc]initWithDictionary:dic];
        if (self.model.loanDeadLine) {
            [self setInfoData];
        }
        [chainRequest addRequest:verifyApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            NSDictionary * dic = [baseRequest responseJSONObject][@"content"][@"personalValue"];
            personVerifyStatusModel * model = [[personVerifyStatusModel alloc]initWithDictionary:dic];
            hasNextStep = [self configTheVerifyStatus:model.bankStatus];
        }];
    }];
    chain.delegate = self;
    [chain start];
}


- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    [self.MainTable reloadData];
    [[WHLoading ShareInstance]hidenHud];
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    // some one of request is failed
}



@end
