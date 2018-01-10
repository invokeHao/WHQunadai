//
//  CPLExtraCreditViewController.m
//  qunadai
//
//  Created by wang on 2017/11/2.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#define KTextFieldMargin 20

#import "CPLExtraCreditViewController.h"
#import "CPLProductListViewController.h"
#import "QNDPhotoCreditViewController.h"

#import "WHVerify.h"
#import "QNDQueryCityByCodeApi.h"

#import "QNDCityModel.h"

#import "CPLProgressView.h"
#import "WHTablePickerVIew.h"
#import "WHCityPicker.h"
@interface CPLExtraCreditViewController ()<UIScrollViewDelegate>

@property (strong,nonatomic)UIScrollView * mainScroller;

@property (strong,nonatomic)CPLProgressView * progressView;

@property (strong,nonatomic)UILabel * provinceLabel;//省份

@property (strong,nonatomic)UILabel * cityLabel;//城市

@property (strong,nonatomic)UILabel * districtLabel;//区

@property (strong,nonatomic)UITextField * livingTextField;//现居住地址

@property (strong,nonatomic)UILabel * shebaoLabel;//是否缴纳社保

@property (strong,nonatomic)UITextField * contactNameText;//紧急联系人

@property (strong,nonatomic)UILabel * contactTypeLabel;//紧急联系人关系

@property (strong,nonatomic)UITextField * contactNumText;//紧急联系人电话

@property (strong,nonatomic)UIButton * nextStepBtn;//下一步

@property (strong,nonatomic)NSMutableArray * provinceArray;//省份列表

@property (strong,nonatomic)NSMutableArray * cityArray;//城市列表

@property (strong,nonatomic)NSMutableArray * districtArray;//区列表

@end

@implementation CPLExtraCreditViewController
{
    NSMutableDictionary * attrs;
    NSString * areaStr;//地址str
    NSString * provinceCode;//省份code
    NSString * cityCode;//城市code
    NSString * districtCode;//区域code
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NOTIF_ADD(UIKeyboardWillChangeFrameNotification, keyboardWillChange:);
    NOTIF_ADD(UITextFieldTextDidChangeNotification, textFieldDidChanged:);
    [self layoutViews];
    [self setupCityDataWithCode:@"100000"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"完善额外信息"];
    self.title = @"完善信息";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"完善额外信息"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NOTIF_REMVWITHNAME(UITextFieldTextDidChangeNotification);
        NOTIF_REMVWITHNAME(UIKeyboardWillChangeFrameNotification);
    } @catch (NSException *exception) {
    } @finally {
    }
}

-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainScroller = [[UIScrollView alloc]init];
    [_mainScroller setFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64)];
    _mainScroller.backgroundColor = [UIColor whiteColor];
    _mainScroller.showsVerticalScrollIndicator = NO;
    _mainScroller.contentSize = CGSizeMake(ViewWidth, ViewHeight-64+1);
    _mainScroller.delegate = self;
    _mainScroller.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_mainScroller];
    
    _progressView = [[CPLProgressView alloc]initWithFinishStep:ExtraInfoFinish andFrame:CGRectMake(0, 0, ViewWidth, 100)];
    [_mainScroller addSubview:_progressView];
    
    UIImageView * lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_progressView.frame)+35, 7, 386)];
    [lineImageV setImage:[UIImage imageNamed:@"mes_color_long"]];
    [_mainScroller addSubview:lineImageV];
    //开始布局长列
    
    attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QNDFont(15.0);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    //省份
    UIView * provinceView = [self setupViewForSelectdLabel:@"省份" andLabel:self.provinceLabel andFrame:CGRectMake(45, CGRectGetMaxY(_progressView.frame)+30, ViewWidth-90, 35) andTag:1000];
    [_mainScroller addSubview:provinceView];
    //城市
    UIView * cityView = [self setupViewForSelectdLabel:@"城市" andLabel:self.cityLabel andFrame:CGRectMake(45, CGRectGetMaxY(provinceView.frame)+KTextFieldMargin, ViewWidth-90, 35) andTag:1001];
    [_mainScroller addSubview:cityView];
    //区域
    UIView * districtView = [self setupViewForSelectdLabel:@"区域" andLabel:self.districtLabel andFrame:CGRectMake(45, CGRectGetMaxY(cityView.frame)+KTextFieldMargin, ViewWidth-90, 35) andTag:1002];
    [_mainScroller addSubview:districtView];
    //居住地址
    UIView * livingView = [self setUpViewForTextFieldWith:@"现居住地址" andTextField:self.livingTextField andFrame:CGRectMake(45, CGRectGetMaxY(districtView.frame)+KTextFieldMargin, ViewWidth-90, 35)];
    [_mainScroller addSubview:livingView];
    
    UIView * shebaoView = [self setupViewForSelectdLabel:@"是否缴纳社保" andLabel:self.shebaoLabel andFrame:CGRectMake(45, CGRectGetMaxY(livingView.frame)+KTextFieldMargin, ViewWidth-90, 35) andTag:1003];
    [_mainScroller addSubview:shebaoView];
    //紧急联系人姓名
    UIView * contactNameView = [self setUpViewForTextFieldWith:@"紧急联系人" andTextField:self.contactNameText andFrame:CGRectMake(45, CGRectGetMaxY(shebaoView.frame)+KTextFieldMargin, ViewWidth-90, 35)];
    [_mainScroller addSubview:contactNameView];
    
    UIView * contactTypeView = [self setupViewForSelectdLabel:@"紧急联系人关系" andLabel:self.contactTypeLabel andFrame:CGRectMake(45, CGRectGetMaxY(contactNameView.frame)+KTextFieldMargin, ViewWidth-90, 35) andTag:1004];
    [_mainScroller addSubview:contactTypeView];
    
    //紧急联系人电话
    UIView * contactNumView = [self setUpViewForTextFieldWith:@"紧急联系人电话" andTextField:self.contactNumText andFrame:CGRectMake(45, CGRectGetMaxY(contactTypeView.frame)+KTextFieldMargin, ViewWidth-90, 35)];
    [_mainScroller addSubview:contactNumView];
    
    //底部按钮
    [self.nextStepBtn setFrame:CGRectMake(20, CGRectGetMaxY(contactNumView.frame)+40, ViewWidth-40, 40)];
    [_mainScroller addSubview:self.nextStepBtn];
    //如果屏幕比例为ipad
    if (CGRectGetMaxY(self.nextStepBtn.frame)+20 > ViewHeight-64+1) {
        _mainScroller.contentSize = CGSizeMake(ViewWidth, CGRectGetMaxY(self.nextStepBtn.frame)+22);
    }
}

//创建选择框

-(UIView*)setupViewForSelectdLabel:(NSString*)labelStr andLabel:(UILabel*)selectLabel andFrame:(CGRect)frame andTag:(int)tag{
    UIView * backView = [[UIView alloc]initWithFrame:frame];
    backView.tag = tag;
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor clearColor];
    
    UILabel * leftLabel = [[UILabel alloc]init];
    leftLabel.font = QNDFont(14.0);
    leftLabel.textColor = QNDRGBColor(181, 188, 204);
    leftLabel.text = labelStr;
    [backView addSubview:leftLabel];
    
    [backView addSubview:selectLabel];
    
    UIView * bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = QNDRGBColor(242, 242, 242);
    [backView addSubview:bottomLine];
    
    UIImageView * moreView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mes_icon_more"]];
    [backView addSubview:moreView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelectTheInfo:)];
    [backView addGestureRecognizer:tap];

    
    CGFloat textW = [labelStr sizeWithAttributes:@{NSFontAttributeName : QNDFont(14.0)}].width + 10;
    
    WHLog(@"%f",textW);
    NSNumber * widthNum = [NSNumber numberWithFloat:textW];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.equalTo(@15);
        make.width.equalTo(widthNum);
    }];

    [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftLabel);
        make.left.mas_equalTo(leftLabel.mas_right).with.offset(20);
        make.height.equalTo(@30);
        make.right.equalTo(@-20);
    }];
    
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftLabel);
        make.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    return backView;
}
//创建输入框
-(UIView*)setUpViewForTextFieldWith:(NSString*)labelStr andTextField:(UITextField*)textfield andFrame:(CGRect)frame{
    UIView * backView = [[UIView alloc]initWithFrame:frame];
    backView.backgroundColor = [UIColor clearColor];
    
    UILabel * leftLabel = [[UILabel alloc]init];
    leftLabel.font = QNDFont(14.0);
    leftLabel.textColor = QNDRGBColor(181, 188, 204);
    leftLabel.text = labelStr;
    [backView addSubview:leftLabel];
    
    [backView addSubview:textfield];
    
    UIView * bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = QNDRGBColor(242, 242, 242);
    [backView addSubview:bottomLine];
    
    CGFloat textW = [labelStr sizeWithAttributes:@{NSFontAttributeName : QNDFont(14.0)}].width + 10;
    
    WHLog(@"%f",textW);
    NSNumber * widthNum = [NSNumber numberWithFloat:textW];

    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.equalTo(@15);
        make.width.equalTo(widthNum);
    }];
    
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftLabel);
        make.left.mas_equalTo(leftLabel.mas_right).with.offset(20);
        make.height.equalTo(@30);
        make.right.equalTo(@-20);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    return backView;
}

#pragma mark- 选择数据
-(void)tapToSelectTheInfo:(UITapGestureRecognizer*)tap{
    UIView * view = tap.view;
    [self.view endEditing:YES];
    @WHWeakObj(self);
    @WHStrongObj(self);
    NSMutableArray * sourceArr = [NSMutableArray array];
    switch (view.tag) {
        case 1000:{
            //省份
            for (QNDCityModel * model in self.provinceArray) {
                [sourceArr addObject:model.name];
            }
            [WHTablePickerView showPickTableWithSouceArr:sourceArr andSelectBlock:^(NSString *selectedStr, NSInteger index) {
                Strongself.provinceLabel.text = selectedStr;
                //拿到paretnCode
                QNDCityModel * model = Strongself.provinceArray[index];
                provinceCode = model.code;
                [Strongself setupCityDataWithCode:provinceCode];
            }];
            break;}
        case 1001:{
            //城市
            for (QNDCityModel * model in self.cityArray) {
                [sourceArr addObject:model.name];
            }
            [WHTablePickerView showPickTableWithSouceArr:sourceArr andSelectBlock:^(NSString *selectedStr, NSInteger index) {
                Strongself.cityLabel.text = selectedStr;
                //拿到paretnCode
                QNDCityModel * model = Strongself.cityArray[index];
                cityCode = model.code;
                [Strongself setupCityDataWithCode:cityCode];
            }];
            break;}
        case 1002:{
            //区域
            for (QNDCityModel * model in self.districtArray) {
                [sourceArr addObject:model.name];
            }
            [WHTablePickerView showPickTableWithSouceArr:sourceArr andSelectBlock:^(NSString *selectedStr, NSInteger index) {
                Strongself.districtLabel.text = selectedStr;
                //拿到paretnCode
                QNDCityModel * model = Strongself.districtArray[index];
                districtCode = model.code;
                [Strongself setupCityDataWithCode:districtCode];
            }];
            break;}
        case 1003:{
            //社保
            [WHTablePickerView showPickTableWithSouceArr:@[@"缴纳本地社保",@"未缴纳社保"] andSelectBlock:^(NSString *selectedStr,NSInteger index) {
                Strongself.shebaoLabel.text = selectedStr;
                Strongself.model.shebao_type = index + 1;
            }];
            break;}
        case 1004:{
            //紧急联系人关系
            [WHTablePickerView showPickTableWithSouceArr:@[@"配偶",@"父母",@"兄弟姐妹",@"子女",@"同事",@"同学",@"朋友"] andSelectBlock:^(NSString *selectedStr,NSInteger index) {
                Strongself.contactTypeLabel.text = selectedStr;
                Strongself.model.contact1_type = index;
            }];
            break;}
        default:
            break;
    }
    [self checkTheInfo];
}

#pragma mark -点击下一步 提交信息
-(void)pressToNextStep:(UIButton*)button{
    QNDPhotoCreditViewController * photoVC = [[QNDPhotoCreditViewController alloc]init];
    photoVC.model = self.model;
    [self.navigationController pushViewController:photoVC animated:YES];
}
#pragma mark -根据上一级code获取地区列表
-(void)setupCityDataWithCode:(NSString*)code{
    QNDQueryCityByCodeApi * api = [[QNDQueryCityByCodeApi alloc]initWithParentCode:code];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            NSArray * sourceArr = [request responseJSONObject][@"data"];
            NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary * dic in sourceArr) {
                QNDCityModel * model = [[QNDCityModel alloc]initWithDictionary:dic];
                [arr addObject:model];
            }
            //处理数据
            [self configTheData:arr];
        }else{
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

-(void)configTheData:(NSMutableArray*)arr{
    QNDCityModel * model = [arr firstObject];
    switch (model.levelType) {
        case 1:{
            //省份
            [self.provinceArray addObjectsFromArray:arr];
            break;}
        case 2:{
            //城市
            self.cityLabel.text = @"";
            self.districtLabel.text = @"";
            [self.cityArray removeAllObjects];
            [self.cityArray addObjectsFromArray:arr];
            break;};
        case 3:{
            //区域
            self.districtLabel.text = @"";
            [self.districtArray addObjectsFromArray:arr];
            break;}
        default:
            break;
    }
}


#pragma mark- 监控textField的输入内容
-(void)textFieldDidChanged:(NSNotification*)noc{
    [self checkTheInfo];
}

-(void)checkTheInfo{
    BOOL isSuccess = YES;
    if (self.livingTextField.text.length<2) {
        isSuccess = NO;
    }
    if (self.contactNameText.text.length<2) {
        isSuccess = NO;
    }
    if (![WHVerify checkTelNumber:self.contactNumText.text]) {
        isSuccess = NO;
    }
    if (self.provinceLabel.text.length<2||self.cityLabel.text.length<2||self.districtLabel.text.length<1) {
        isSuccess = NO;
    }
    if (self.shebaoLabel.text.length<2) {
        isSuccess = NO;
    }
    if (self.contactTypeLabel.text.length<2) {
        isSuccess = NO;
    }
    
    self.nextStepBtn.backgroundColor = isSuccess ? ThemeColor : QNDRGBColor(195, 195, 195);
    self.nextStepBtn.userInteractionEnabled = isSuccess;
    if (isSuccess) {
        self.model.living_address = self.livingTextField.text;
        self.model.contact1_name = self.contactNameText.text;
        self.model.contact1_cell = self.contactNumText.text;
        self.model.province = self.provinceLabel.text;
        self.model.city = self.cityLabel.text;
        self.model.district = self.districtLabel.text;
        self.model.districtCode = districtCode;
    }
}


#pragma mark- 懒加载
-(UILabel *)provinceLabel{
    if (!_provinceLabel) {
        _provinceLabel = [self createLabel];
    }
    return _provinceLabel;
}

-(UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [self createLabel];
    }
    return _cityLabel;
}

-(UILabel *)districtLabel{
    if (!_districtLabel) {
        _districtLabel = [self createLabel];
    }
    return _districtLabel;
}

-(UILabel *)shebaoLabel{
    if (!_shebaoLabel) {
        _shebaoLabel = [self createLabel];
    }
    return _shebaoLabel;
}

-(UILabel *)contactTypeLabel{
    if (!_contactTypeLabel) {
        _contactTypeLabel = [self createLabel];
    }
    return _contactTypeLabel;
}

-(UITextField *)livingTextField{
    if (!_livingTextField) {
        _livingTextField = [[UITextField alloc]init];
        _livingTextField.font =QNDFont(14.0);
        _livingTextField.textColor = black74TitleColor;
        _livingTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入详细地址" attributes:attrs];
        _livingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _livingTextField.tintColor = ThemeColor;
        
    }
    return _livingTextField;
}

-(UITextField *)contactNameText{
    if (!_contactNameText) {
        _contactNameText = [[UITextField alloc]init];
        _contactNameText.font =QNDFont(14.0);
        _contactNameText.textColor = black74TitleColor;
        _contactNameText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入紧急联系人" attributes:attrs];
        _contactNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contactNameText.tintColor = ThemeColor;
    }
    return _contactNameText;
}

-(UITextField *)contactNumText{
    if (!_contactNumText) {
        _contactNumText = [[UITextField alloc]init];
        _contactNumText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"紧急联系人电话" attributes:attrs];
        _contactNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contactNumText.keyboardType = UIKeyboardTypeNumberPad;
        _contactNumText.tintColor = ThemeColor;
        _contactNumText.textColor = black74TitleColor;
        _contactNumText.font = QNDFont(14.0);
    }
    return _contactNumText;
}

-(UIButton *)nextStepBtn{
    if (!_nextStepBtn) {
        _nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepBtn.backgroundColor = QNDRGBColor(195, 195, 195);
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepBtn.titleLabel setFont:QNDFont(18)];
        _nextStepBtn.layer.cornerRadius = 20;
        _nextStepBtn.clipsToBounds = YES;
        _nextStepBtn.userInteractionEnabled = NO;
        [_nextStepBtn addTarget:self action:@selector(pressToNextStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepBtn;
}

-(NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _provinceArray;
}

-(NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cityArray;
}

-(NSMutableArray *)districtArray{
    if (!_districtArray) {
        _districtArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _districtArray;
}

-(UILabel *)createLabel{
    UILabel * label = [[UILabel alloc]init];
    label.font = QNDFont(14.0);
    label.textColor = black74TitleColor;
    return label;
}

#pragma mark-键盘相关
- (void)keyboardWillChange:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - ViewHeight;
    if (keyFrame.origin.y>ViewHeight) {
        moveY = keyFrame.origin.y-ViewHeight;
    }
    if (moveY<0&&[self.livingTextField isFirstResponder]) {
        moveY += 150;
    }
    if (moveY<0&&[self.contactNameText isFirstResponder]) {
        moveY += 150;
    }
    WHLog(@"moveF==%f",moveY);
    [UIView animateWithDuration:duration animations:^{
        self.mainScroller.transform=CGAffineTransformMakeTranslation(0, moveY);
    }];
}



@end
