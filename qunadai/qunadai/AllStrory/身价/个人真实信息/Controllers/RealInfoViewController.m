//
//  RealInfoViewController.m
//  qunadai
//
//  Created by wang on 17/3/31.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "RealInfoViewController.h"
#import "YellowAlertTableViewCell.h"
#import "WHTablePickerVIew.h"

#import "userDetailInfoApi.h"
#import "userDetailInfoPostApi.h"

#import "userDetailInfoModel.h"

#import "WHCityPicker.h"
#import "WHVerify.h"


#define KTextFieldWidth 150

@interface RealInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * titleArray;//
    NSMutableArray * infoArray;
    BOOL hasDelete;
}

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)UITextField * loanText;//借款额度

@property (strong,nonatomic)UITextField * incomeText;//收入

@property (strong,nonatomic)NSMutableArray * dataArray;

@property (strong,nonatomic)userDetailInfoModel * model;

@property (assign,nonatomic)int sectionNum;


@end

@implementation RealInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self layoutViews];
    NOTIF_ADD(UITextFieldTextDidChangeNotification, textFieldDidChanged:);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"真实信息";
    [self setupData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:UITextFieldTextDidChangeNotification];
    } @catch (NSException *exception) {
        WHLog(@"大哥我删错了，还不行吗");
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
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    [self.view addSubview:_MainTable];
    _MainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}


#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return hasDelete ? 2 : 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==_sectionNum ? titleArray.count : 1;
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
        return hasDelete ? 60 : 45;
    }else{
        return 60;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"realInfoCell"];
    
    __weak typeof(self) weakSelf =self;
    __strong typeof(self) strongSelf = weakSelf;
    cell.textLabel.font= QNDFont(15.0);
    cell.textLabel.textColor = black74TitleColor;
    cell.detailTextLabel.font = QNDFont(15.0);
    cell.detailTextLabel.textColor = defaultPlaceHolderColor;
    cell.detailTextLabel.text = @"请选择";
    
    UIImageView * moreView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 6)];
    [moreView setImage:[UIImage imageNamed:@"xiajiantou"]];
    cell.accessoryView = moreView;
    if (indexPath.section==0&&!hasDelete) {
        //提示cell
        YellowAlertTableViewCell * yellowCell = [[YellowAlertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yellowCell"];
        yellowCell.selectionStyle = UITableViewCellSelectionStyleNone;
        yellowCell.alertLabel.text = @"恶意填写信息会对您的额度造成不良影响";
        [yellowCell setYellowBlock:^{
            hasDelete = YES;
            _sectionNum=0;
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
                cell.detailTextLabel.textColor = black74TitleColor;
                cell.detailTextLabel.text = infoArray[indexPath.row];
            }
        }
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.hidden = YES;
        cell.accessoryView.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        //按钮
        UIButton * verifyBtn =[self createVerifyBtn];
        [cell addSubview:verifyBtn];
        [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.right.equalTo(@-15);
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
                cell.detailTextLabel.textColor = black74TitleColor;
            }];
        }else{
            [self.view endEditing:YES];
            [WHTablePickerView showPickTableWithSouceArr:_dataArray[indexPath.row] andSelectBlock:^(NSString *selectedStr,NSInteger index) {
                cell.detailTextLabel.text = selectedStr;
                cell.detailTextLabel.textColor = black74TitleColor;
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
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:BottomThemeColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [btn addTarget:self action:@selector(verifyTheRealInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 20;
    btn.clipsToBounds = YES;
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
    
    UILabel * unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 15)];
    unitLabel.font = QNDFont(14.0);
    unitLabel.textColor = black74TitleColor;
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
#pragma  mark-提交真实信息

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
        [[WHLoading ShareInstance]hidenHud];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"failed==%@",[request responseJSONObject]);
        [[WHLoading ShareInstance]hidenHud];
    }];
}

-(void)setupData{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    userDetailInfoApi * api = [[userDetailInfoApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        WHLog(@"success==%@",[request responseJSONObject]);
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary * dic = [request responseJSONObject][@"content"][@"userCreditInfo"];
        self.model = [[userDetailInfoModel alloc]initWithDictionary:dic];
        if (self.model.loanDeadLine) {
            [self setInfoData];
        }
        [self.MainTable reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"failure==%@",[request responseJSONObject]);
        [[WHLoading ShareInstance]hidenHud];
    }];
    
}

@end
