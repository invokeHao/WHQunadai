//
//  QNDLoanHomeViewController.m
//  qunadai
//
//  Created by wang on 2017/9/25.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDLoanHomeViewController.h"
#import "ControlAllNavigationViewController.h"
#import "wangTabBarController.h"
#import "AppDelegate.h"
#import "QNDPickValueViewController.h"
#import "SDCycleScrollView.h"

#import "ValueHomeModel.h"
#import "QNDVersonModel.h"

#import "QNDMidCircleView.h"

#import "QNDMoXieVerifyListApi.h"
#import "QNDVersonControlApi.h"

#import "NSString+extention.h"

@interface QNDLoanHomeViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (strong,nonatomic)UIScrollView * mainScroller;

@property (strong,nonatomic)QNDMidCircleView * midBackView;

@end

@implementation QNDLoanHomeViewController
{
    NSString * _valueStr;
    NSMutableArray * verifyArr;
    SDCycleScrollView * cycleScrollView;
    BOOL hadAllVerify;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkTheUpDate];
    [self setupData];
    self.tabBarController.title = @"去哪贷";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)layoutViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mainScroller = [[UIScrollView alloc]init];
    [_mainScroller setFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64)];
    _mainScroller.backgroundColor = [UIColor whiteColor];
    _mainScroller.showsVerticalScrollIndicator = NO;
    _mainScroller.contentSize = CGSizeMake(ViewWidth, ViewHeight-64+1);
    _mainScroller.delegate = self;
    [self.view addSubview:_mainScroller];
    
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, 180 * ViewWidth/375) delegate:self placeholderImage:[UIImage imageNamed:@"loan_banner"]];
    NSArray * imageArr = @[@"loan_banner1",@"loan_banner2",@"loan_banner3"];
    cycleScrollView.imageURLStringsGroup = imageArr;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.mainScroller addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 2.5;

    
    _midBackView = [[QNDMidCircleView alloc]init];
    [_midBackView setFrame:CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame)-10, ViewWidth, 306)];
    [self.mainScroller addSubview:_midBackView];
    [self setupBottomBtn];
}

-(void)setupBottomBtn{
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setTitle:@"立即借款" forState:UIControlStateNormal];
    [bottomBtn setBackgroundColor:ThemeColor];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn.titleLabel setFont:QNDFont(18)];
    [bottomBtn setFrame:CGRectMake(12, CGRectGetMaxY(_midBackView.frame)+5, ViewWidth-24, 46)];
    bottomBtn.layer.cornerRadius = 2;
    bottomBtn.clipsToBounds = YES;
    [bottomBtn addTarget:self action:@selector(pressTheBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer * gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(1, 1);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.frame = bottomBtn.bounds;
    gradient.colors = [NSArray arrayWithObjects:ThemeColor,QNDRGBColor(247, 182, 28), nil];
    [bottomBtn.layer insertSublayer:gradient atIndex:0];
    [self.mainScroller addSubview:bottomBtn];
    //如果屏幕比例为ipad
    if (CGRectGetMaxY(bottomBtn.frame)+30 > ViewHeight-64+1) {
        _mainScroller.contentSize = CGSizeMake(ViewWidth, CGRectGetMaxY(bottomBtn.frame)+30);
    }
}

#pragma mark - 底部按钮的点击事件
-(void)pressTheBottomBtn:(UIButton*)button{
    if (!KGetACCESSTOKEN) {
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
        return;
    }
    //判断是否完善过信息
    if (hadAllVerify){
        QNDPickValueViewController * pickVC = [[QNDPickValueViewController alloc]init];
        pickVC.loanvalueStr = _valueStr;
        [self.navigationController pushViewController:pickVC animated:YES];
    }else{
        //跳到我的信息页面
        [[WHTool shareInstance]showAlterViewWithMessage:@"完善信息后即可借款，是否去完善？" andDoneBlock:^(UIAlertAction * _Nonnull action) {
            wangTabBarController * wangTabVC = [[wangTabBarController alloc]init];
            wangTabVC.selectedIndex = 1;
            ControlAllNavigationViewController * allNavVC = [[ControlAllNavigationViewController alloc]initWithRootViewController:wangTabVC];
            AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController=allNavVC;
        }];
    }
}

-(void)setupData{
    if (!KGetACCESSTOKEN) {
        _valueStr = @"500";
        [self refereshTheData];
        return; 
    }
    [[WHLoading ShareInstance]showImageHUD:self.view];
    QNDMoXieVerifyListApi * api = [[QNDMoXieVerifyListApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        [[WHLoading ShareInstance]hidenHud];
        NSDictionary * sourcedic = [request responseJSONObject][@"data"];
        ValueHomeModel * model = [[ValueHomeModel alloc]initWithDictionary:sourcedic];
        [self checkTheVerifyStatueWithModel:model];
        _valueStr = FORMAT(@"%ld",[sourcedic[@"valuation"] integerValue]);
        [self refereshTheData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

-(void)checkTheUpDate{
    QNDVersonControlApi * api = [[QNDVersonControlApi alloc]init];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",[request responseJSONObject]);
        BOOL flag = YES;
        BOOL forceUpdate = NO;
        QNDVersonModel * model = nil;
        NSInteger  status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            NSDictionary * dataDic = [request responseJSONObject][@"data"];
            model = [[QNDVersonModel alloc]initWithDictionary:dataDic];
            flag = model.distribution;
            forceUpdate = model.upgradeFlag;
        }else{
        }
        if (!flag) {
            [user setBool:YES forKey:KFirstTime];
            NOTIF_POST(KNOTIFICATION_SUCCESS, [NSNumber numberWithBool:flag]);
        }
        [user setBool:flag forKey:@"isToSubmit"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

-(void)checkTheVerifyStatueWithModel:(ValueHomeModel*)model{
    verifyArr = [NSMutableArray arrayWithCapacity:0];
    if (model) {
        if (model.bankStatus) {
            [verifyArr addObject:model.bankStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (model.ebankStatus) {
            [verifyArr addObject:model.ebankStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (model.alipayStatus) {
            [verifyArr addObject:model.alipayStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (model.taobaoStatus) {
            [verifyArr addObject:model.taobaoStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (model.operatorStatus) {
            [verifyArr addObject:model.operatorStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (model.zxStatus) {
            [verifyArr addObject:model.zxStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (model.zmxyStatus) {
            [verifyArr addObject:model.zmxyStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
        if (model.fundStatus) {
            [verifyArr addObject:model.fundStatus];
        }else{
            [verifyArr addObject:@"CREATED"];
        }
    }
    if ([self verifyFinishTheInfo]) {
        hadAllVerify = YES;
    }else{
        hadAllVerify = NO;
    }
}

-(BOOL)verifyFinishTheInfo{
    if (verifyArr.count<1) {
        return NO;
    }else{
        BOOL  verify = YES;
        for (NSString * item in verifyArr) {
            if (![item isEqualToString:@"SUCCESS"]) {
                verify = NO;
            }
        }
        return verify;
    }
}

-(void)refereshTheData{
    self.midBackView.totalValue = [_valueStr intValue];
    self.midBackView.totalValueLabel.text = FORMAT(@"总额度%@",_valueStr);
}

@end
