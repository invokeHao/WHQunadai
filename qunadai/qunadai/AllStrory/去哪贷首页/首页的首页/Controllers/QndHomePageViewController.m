//
//  HomePageViewController.m
//  qunadai
//
//  Created by wang on 17/3/22.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QndHomePageViewController.h"
#import "DetailProductViewController.h"
#import "WangWebViewController.h"
#import "QNDProductSegementViewController.h"
#import "QNDValueHomePViewController.h"
#import "QNDChildTableViewController.h"

#import "CPLBasicCreditViewController.h"
#import "CPLProductListViewController.h"

#import "productLoanModel.h"
#import "bannerModel.h"

#import "loanProductTableViewCell.h"
#import "WHShareView.h"
#import "QNDCustomHeaderView.h"
#import "WZBSegmentedControl.h"

#import "QNDProHotListApi.h"
#import "QNDProUnappliedListApi.h"
#import "QNDProApplicationListApi.h"
#import "QNDNewLoanListApi.h"
#import "QNDApplicationOrderApi.h"
#import "QNDHomePageInfoApi.h"

#import "NSString+extention.h"

@interface QndHomePageViewController ()<UIScrollViewDelegate,YTKChainRequestDelegate,WHBannerDelegate>
{
    BOOL firstIn;//第一次进入app
    BOOL _hadBrowsedLatestProducts;//是否浏览过最新帖子
    CGFloat _offset;
}

@property (strong,nonatomic)UIScrollView * MainScroll;

@property (strong,nonatomic)QNDCustomHeaderView * headerView;

@property (strong,nonatomic)QNDChildTableViewController * hotTableVC;

@property (strong,nonatomic)QNDChildTableViewController * latestTableVC;

@property (strong,nonatomic)QNDChildTableViewController * unapplicationTableVC;

@property (strong,nonatomic)QNDChildTableViewController * applicationTableVC;

@property (strong,nonatomic)WZBSegmentedControl * segment;

@property (assign,nonatomic)NSInteger selectIndex;//选中的下标

@property (assign,nonatomic)NSInteger totalAmount;//总金额

@property (strong,nonatomic)NSMutableArray * hotArray;

@property (strong,nonatomic)NSMutableArray * lastProArray;

@property (strong,nonatomic)NSMutableArray * unApplicationArray;

@property (strong,nonatomic)NSMutableArray * applicationArray;

@property (strong,nonatomic)NSMutableArray * bannerArray;//banner列表

@property (assign,nonatomic)NSInteger UnapplicationNum;//未申请数量

@property (assign,nonatomic)NSInteger applicationNum;//已申请数量

@property (assign,nonatomic)NSString * announceStr;//公告

@property (assign,nonatomic)CGFloat TopMargin;

@end

@implementation QndHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _TopMargin = 180;
    _selectIndex = 0;
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.navigationItem setRightBarButtonItems:nil];
    self.tabBarController.title = @"去哪贷";
    [self setupData];
    [TalkingData trackPageBegin:@"首页"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"首页"];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)dealloc{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:KNOTIFICATION_LOGOUT];
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)layoutViews{
    firstIn = YES;
    // 底部横向滑动的scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = QNDRGBColor(242, 242, 242);
    scrollView.delegate = self;
    // 设置滑动区域
    scrollView.contentSize = CGSizeMake(4 * ViewWidth, 0);
    scrollView.pagingEnabled = YES;
    self.MainScroll = scrollView;

    _headerView = [[QNDCustomHeaderView alloc] initWithFrame:CGRectMake(0, 64, ViewWidth, _TopMargin+44)];
    _headerView.delegate = self;
    [self.view addSubview:_headerView];
    [self setupSegment];
    
    //创建子tableViewVC
    _hotTableVC = [self setupChildVCWithType:HotPorType x:0];
    _latestTableVC = [self setupChildVCWithType:LatestProType x:1];
    _unapplicationTableVC = [self setupChildVCWithType:UnapplicationProType x:2];
    _applicationTableVC = [self setupChildVCWithType:ApplicationProType x:3];
}

-(void)setupSegment{
    if (self.segment) {
        [self.segment.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    // 创建segmentedControl
    @WHWeakObj(self);
    @WHStrongObj(self);
    NSString * unapplicationStr = FORMAT(@"未申请(%ld)",_UnapplicationNum);
    NSString * applicationStr = FORMAT(@"已申请(%ld)",_applicationNum);

    WZBSegmentedControl *sectionView = [WZBSegmentedControl segmentWithFrame:(CGRect){0, _TopMargin, ViewWidth, 44} titles:@[@"热门", @"新口子", unapplicationStr,applicationStr] tClick:^(NSInteger index) {
        Strongself.MainScroll.contentOffset = CGPointMake(index * ViewWidth, 0);
        // 刷新最大OffsetY
        [Strongself reloadMaxOffsetY];
        [Strongself TDWithIndex:index];
    }];
    // 赋值给全局变量
    self.segment = sectionView;
    
    // 设置其他颜色
    [sectionView setNormalColor:QNDRGBColor(195, 195, 195) selectColor:ThemeColor sliderColor:ThemeColor edgingColor:[UIColor clearColor] edgingWidth:0];
    sectionView.backgroundColor = [UIColor whiteColor];
    // 去除圆角
    sectionView.layer.cornerRadius = sectionView.backgroundView.layer.cornerRadius = .0f;
    // 调下frame
    CGRect frame = sectionView.backgroundView.frame;
    frame.origin.y = frame.size.height - 1.5;
    frame.size.height = 1;
    sectionView.backgroundView.frame = frame;
    [self.headerView addSubview:sectionView];
}

-(QNDChildTableViewController*)setupChildVCWithType:(QNDProListType)type x:(CGFloat)x{
    QNDChildTableViewController * childVC ;
    @WHWeakObj(self);
    childVC = [[QNDChildTableViewController alloc]initWithPropertyType:type andNum:^(NSInteger number) {
            [Weakself setupData];
    }];
    childVC.view.frame = CGRectMake(x*ViewWidth, 0, self.view.width, self.view.height-64);
    [self.MainScroll addSubview:childVC.view];
    [self addChildViewController:childVC];
    [childVC.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial context:nil];
    return childVC;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UITableView *tableView = object;
        CGFloat contentOffsetY = tableView.contentOffset.y;

        // 如果滑动没有超过140
        if (contentOffsetY < _TopMargin) {
            // 让这三个tableView的偏移量相等
            for (QNDChildTableViewController *vc in self.childViewControllers) {
                if (vc.tableView.contentOffset.y != tableView.contentOffset.y) {
                    vc.tableView.contentOffset = tableView.contentOffset;
                }
            }
            CGFloat headerY = -tableView.contentOffset.y;
            if (headerY > 0) {
                headerY = 0;
            }
            // 改变headerView的y值
            [self.headerView changeY:headerY];

            // 一旦大于等于140了，让headerView的y值等于184，就停留在上边了
        } else if (contentOffsetY >= _TopMargin) {
            [self.headerView changeY:-_TopMargin];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.MainScroll) {
        [self.segment setContentOffset:CGPointMake(scrollView.contentOffset.x/4, 0)];
    }
}
// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 刷新最大OffsetY
    [self reloadMaxOffsetY];
}

// 刷新最大OffsetY，让三个tableView同步
- (void)reloadMaxOffsetY {
    // 计算出最大偏移量
    CGFloat maxOffsetY = 0;
    for (QNDChildTableViewController *vc in self.childViewControllers) {
        if (vc.tableView.contentOffset.y > maxOffsetY) {
            maxOffsetY = vc.tableView.contentOffset.y;
        }
    }
    // 如果最大偏移量大于184，处理下每个tableView的偏移量
    if (maxOffsetY > _TopMargin) {
        for (QNDChildTableViewController *vc in self.childViewControllers) {
            if (vc.tableView.contentOffset.y < _TopMargin) {
                vc.tableView.contentOffset = CGPointMake(0, _TopMargin);
            }
        }
    }
}

#pragma mark- WHBanner的delegate
-(void)pressBannerActionUrl:(NSString *)url andName:(NSString *)name{
    WangWebViewController * webVC = [[WangWebViewController alloc]init];
    webVC.url= url;
    webVC.webType = name;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark- 数据统计
-(void)TDWithIndex:(NSInteger)index{
    switch (index) {
        case 1:{
            [TalkingData trackEvent:@"新口子" label:@"新口子"];
            break;}
        case 2:{
            [TalkingData trackEvent:@"未申请" label:@"未申请"];
            break;}
        case 3:{
            [TalkingData trackEvent:@"已申请" label:@"已申请"];
            break;}
        default:
            break;
    }
}


#pragma mark- 请求数据
-(void)setupData{
    [[WHLoading ShareInstance]hidenHud];
//    [[WHLoading ShareInstance]showImageHUD:self.view];
    if (firstIn) {
        [[WHLoading ShareInstance]showImageHUD:self.view];
    }
    if (self.bannerArray.count>0) {
        [_bannerArray removeAllObjects];
    }
    if (self.unApplicationArray.count>0) {
        [_unApplicationArray removeAllObjects];
    }
    if (self.applicationArray.count>0) {
        [_applicationArray removeAllObjects];
    }
    if (self.hotArray.count>0) {
        [_hotArray removeAllObjects];
    }
    if (self.lastProArray.count>0) {
        [_lastProArray removeAllObjects];
    }
    //热门列表api
    QNDProHotListApi * hotApi = [[QNDProHotListApi alloc]initWithPage:1];
    //最新口子api
    QNDNewLoanListApi * newApi = [[QNDNewLoanListApi alloc]initWithPage:1];
    
    //未申请列表api
    YTKRequest * unapplicationApi;
    if (KGetACCESSTOKEN) {
        unapplicationApi = [[QNDProUnappliedListApi alloc]initWithPage:1];
    }else{
        unapplicationApi = [[QNDProHotListApi alloc]initWithPage:1];
    }
    //已申请列表api
    QNDProApplicationListApi * applicationApi = [[QNDProApplicationListApi alloc]initWithPage:1];
    //获取额外信息
    QNDHomePageInfoApi * infoApi = [[QNDHomePageInfoApi alloc]init];
    
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    //获取首页额外信息
    [chain addRequest:infoApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        WHLog(@"%@",baseRequest.responseJSONObject);
        NSInteger status = [[baseRequest responseJSONObject][@"status"]integerValue];
        if (status==1) {
            NSDictionary * dataDic = [baseRequest responseJSONObject][@"data"];
           _totalAmount = [dataDic[@"availableAmount"] integerValue];//额度
            NSArray * bannerArr = dataDic[@"bannerInfo"];
            for (NSDictionary * dic in bannerArr) {
                bannerModel * model = [[bannerModel alloc]initWithDictionary:dic];
                [self.bannerArray addObject:model];
            }
        }else if(status==-1){
            [[WHTool shareInstance]GoToLoginWithFromVC:self];
            return;
        }else{[self.view makeCenterToast:[baseRequest responseJSONObject][@"msg"]];}
    }];
    //获取首页产品列表
    [chain addRequest:unapplicationApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
       WHLog(@"%@",baseRequest.responseJSONObject);
        //未申请列表 
        NSArray * sourceArr = baseRequest.responseJSONObject[@"data"][@"dataList"];
        self.UnapplicationNum =[baseRequest.responseJSONObject[@"data"][@"totalCount"]integerValue];
        for (NSDictionary * dic in sourceArr) {
            productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
            [self.unApplicationArray addObject:model];
        }
        //热门列表
        [chainRequest addRequest:hotApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            NSArray * sourceArr = baseRequest.responseJSONObject[@"data"][@"dataList"];
            for (NSDictionary * dic in sourceArr) {
                productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
                [self.hotArray addObject:model];
            }
            //最新口子
            [chainRequest addRequest:newApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
                NSArray * sourceArr = baseRequest.responseJSONObject[@"data"][@"dataList"];
                for (NSDictionary * dic in sourceArr) {
                    productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
                    [self.lastProArray addObject:model];
                }
            }];
        }];
        if (KGetACCESSTOKEN) {
            [chainRequest addRequest:applicationApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//                WHLog(@"%@",baseRequest.responseJSONObject);
                //已申请
                NSInteger status = [[baseRequest responseJSONObject][@"status"]integerValue];
                if (status==1) {
                    NSDictionary * dataDic = [baseRequest responseJSONObject][@"data"];
                    self.applicationNum =[baseRequest.responseJSONObject[@"data"][@"totalCount"]integerValue];
                    NSArray * sourceArr = dataDic[@"dataList"];
                    for (NSDictionary * dic in sourceArr) {
                        productLoanModel * model = [[productLoanModel alloc]initWithDictionary:dic];
                        model.applied = YES;
                        [self.applicationArray addObject:model];
                    }
                }else{[self.view makeCenterToast:[baseRequest responseJSONObject][@"msg"]];
                }
            }];
        }else{
            self.applicationNum = 0;
        }
    }];
    chain.delegate = self;
    [chain start];
}

- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    [[WHLoading ShareInstance]hidenHud];
    firstIn = NO;//不再显示加载
    [[WHOopsView shareInstance]hidenTheOops];
    //刷新选择栏
    [self.segment setTheUnapplicationNum:self.UnapplicationNum andApplicationNum:self.applicationNum];
    //赋值
    [self.headerView setDataArray:self.bannerArray];
    
    [self.headerView setFrame:CGRectMake(0, 64, ViewWidth, _TopMargin+44)];
    [self.segment setFrame:CGRectMake(0, _TopMargin, ViewWidth, 44)];

    for (QNDChildTableViewController * childVC in self.childViewControllers) {
         [childVC setTopHeight:_TopMargin+44];
        childVC.currentpage = 1;
        if (childVC == self.applicationTableVC) {
            [childVC setTitleStr:@"以下口子都已经申请过了" andValue:1];
        }else{
            [childVC setTitleStr:@"不上征信" andValue:self.totalAmount];
        }
    }
    [self.hotTableVC setDataArray:self.hotArray];
    [self.latestTableVC setDataArray:self.lastProArray];
    [self.unapplicationTableVC setDataArray:self.unApplicationArray];
    [self.applicationTableVC setDataArray:self.applicationArray];
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    WHLog(@"%ld",request.responseStatusCode);
    [[WHLoading ShareInstance]hidenHud];
    firstIn = NO;
    if (request.responseStatusCode==471||request.responseStatusCode==401) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KUserToken]) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:KUserToken];
        }
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
    }
    if (request.responseStatusCode==0) {
        [[WHLoading ShareInstance]hidenHud];
        @WHWeakObj(self);
        [[WHOopsView shareInstance]showTheOopsViewOneTheView:self.view WithDoneBlock:^{
            [Weakself setupData];
        }];
    }
}
-(NSMutableArray *)hotArray{
    if (!_hotArray) {
        _hotArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotArray;
}

-(NSMutableArray*)lastProArray{
    if (!_lastProArray) {
        _lastProArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _lastProArray;
}


-(NSMutableArray *)unApplicationArray{
    if (!_unApplicationArray) {
        _unApplicationArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _unApplicationArray;
}

-(NSMutableArray*)applicationArray{
    if (!_applicationArray) {
        _applicationArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _applicationArray;
}

-(NSMutableArray*)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _bannerArray;
}
@end
