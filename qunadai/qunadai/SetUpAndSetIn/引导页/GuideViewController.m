//
//  GuideViewController.m
//  qunadai
//
//  Created by wang on 17/3/22.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

#import "ControlAllNavigationViewController.h"
#import "wangTabBarController.h"     
#import "QNDProductSegementViewController.h"

#define KImageWidth 280
#define KImageHeight 300



@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIPageControl * myPageControl;
}
@property (nonatomic,strong) UIScrollView *guideScroller;//引导的view

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [TalkingData trackPageBegin:@"引导页"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"引导页"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(CGFloat)getTheScaleWith:(CGFloat)num1 and:(CGFloat)num2{
    CGFloat scale = (CGFloat)num1/num2;
    return scale;
}

-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _guideScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 575*ViewHeight/667)];
    _guideScroller.delegate = self;
    _guideScroller.contentSize = CGSizeMake(ViewWidth*3, 5);
    _guideScroller.pagingEnabled = YES;
    _guideScroller.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_guideScroller];
    
    myPageControl = [[UIPageControl alloc]init];
    myPageControl.numberOfPages = 3;
    myPageControl.currentPage = 0;
    myPageControl.enabled = NO;
    myPageControl.pageIndicatorTintColor = lightGrayBackColor;
    myPageControl.currentPageIndicatorTintColor = ThemeColor;
    NSNumber * bottom = [NSNumber numberWithFloat:-32*ViewHeight/667];
    [self.view addSubview:myPageControl];
    [myPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.equalTo(bottom);
        make.size.mas_equalTo(CGSizeMake(48, 8));
    }];
    
    [self setupDetailViews];
}

-(void)setupDetailViews{
    NSMutableArray *imageArray = [@[@"onboarding_1",@"onboarding_2",@"onboarding_3"] mutableCopy];
    
    NSMutableArray *titleArray = [@[@"随时随地贷款无忧",@"优选机构快速放款",@"高效导航智能匹配"]mutableCopy];
//
    NSMutableArray *remindArray = [@[@"周转方便 急你所需",@"靠谱省心的贷款平台",@"贴心细腻 精准推荐"]mutableCopy];
    
    CGFloat iconWidth = 369*ViewWidth/375;
    CGFloat iconR = (float)316 / 369;
    CGFloat x = (ViewWidth-iconWidth)/2;
    for (int i = 0; i< 3; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 1.设置frame
        imageView.frame = CGRectMake(i * ViewWidth + x, 50*ViewHeight/667 ,iconWidth , iconWidth * iconR);
        // 2.设置图片
        NSString *imgName = imageArray[i];
        imageView.image = [UIImage imageNamed:imgName];
        [_guideScroller addSubview:imageView];
        
        CGFloat title1Y = 67*ViewHeight/667;
        
        UILabel*themeLabel=[[UILabel alloc]initWithFrame:CGRectMake(i*ViewWidth, CGRectGetMaxY(imageView.frame)+title1Y, ViewWidth, 32)];
        themeLabel.text=titleArray[i];
        themeLabel.textColor=ThemeColor;
        themeLabel.font = QNDFont(30);
        themeLabel.textAlignment = NSTextAlignmentCenter;
        [_guideScroller addSubview:themeLabel];
        
        CGFloat title2Y = 10*ViewHeight/667;
        UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*ViewWidth, CGRectGetMaxY(themeLabel.frame)+title2Y, ViewWidth, 21)];
        remindLabel.text = remindArray[i];
        remindLabel.font = QNDFont(20);
        remindLabel.textColor=[UIColor colorWithRed:238.0/255.0 green:100.0/255.0 blue:43.0/255.0 alpha:0.5];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [_guideScroller addSubview:remindLabel];
        
        UIButton * btn = [self createBtnWithTitle:@"立即体验" andTag:200];
        [_guideScroller addSubview:btn];
        CGFloat x = (ViewWidth-140)/2+2*ViewWidth;
        CGFloat btnY = 30 * ViewHeight / 667;
        NSNumber * leftX = [NSNumber numberWithFloat:x];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftX);
            make.top.mas_equalTo(remindLabel.mas_bottom).with.offset(btnY);
            make.size.mas_equalTo(CGSizeMake(140, 30));
        }];
    }
    
    UIButton*igronBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [igronBtn setBackgroundColor:lightGrayBackColor];
    [igronBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [igronBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [igronBtn.titleLabel setFont:QNDFont(12.0)];
    igronBtn.layer.cornerRadius=13;
    igronBtn.layer.masksToBounds=YES;
    [igronBtn setFrame:CGRectMake(ViewWidth-10-50, 30, 50, 26)];
    [igronBtn addTarget:self action:@selector(gotoMainVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:igronBtn];
}

-(UIButton*)createBtnWithTitle:(NSString*)title andTag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:ThemeColor forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.titleLabel setFont:QNDFont(17.0)];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.borderColor = ThemeColor.CGColor;
    button.layer.borderWidth = 0.5;
    button.clipsToBounds = YES;
    button.tag = tag;
    [button addTarget:self action:@selector(gotoDoSomeThings:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int PageNumber = (int)scrollView.contentOffset.x/ViewWidth;
    myPageControl.currentPage = PageNumber;
    if (scrollView.contentOffset.x>ViewWidth*2+20) {
        [self gotoMainVC];
    }
}

-(void)gotoDoSomeThings:(UIButton*)button{
    [self gotoMainVC];
}

-(void)gotoMainVC{
    ControlAllNavigationViewController * allNavVC = [[ControlAllNavigationViewController alloc]initWithRootViewController:[wangTabBarController new]];
    AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController=allNavVC;
}
@end
