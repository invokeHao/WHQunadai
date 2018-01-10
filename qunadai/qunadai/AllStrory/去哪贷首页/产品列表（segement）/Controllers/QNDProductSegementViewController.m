//
//  QNDProductSegementViewController.m
//  qunadai
//
//  Created by wang on 2017/9/7.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDProductSegementViewController.h"
#import "QNDChildTableViewController.h"
#import "MJCSegmentInterface.h"


@interface QNDProductSegementViewController ()<MJCSegmentDelegate>

@end

@implementation QNDProductSegementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [TalkingData trackPageBegin:@"贷款列表访问"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"贷款列表访问"];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titlesArr = @[@"快速放款",@"超低利率",@"超高额度"];
    
    QNDChildTableViewController *vc1 = [[QNDChildTableViewController alloc]initWithPropertyType:HotPorType];
    QNDChildTableViewController *vc2 = [[QNDChildTableViewController alloc]initWithPropertyType:HotPorType];
    QNDChildTableViewController *vc3 = [[QNDChildTableViewController alloc]initWithPropertyType:HotPorType];
    NSArray * VCArr = @[vc1,vc2,vc3];
    
    MJCSegmentInterface *lala = [[MJCSegmentInterface alloc]init];
    lala.frame = CGRectMake(0,20,self.view.jc_width, self.view.jc_height-20);
    lala.delegate= self;
    lala.backgroundColor = [UIColor whiteColor];
    lala.titleBarStyles = MJCTitlesScrollStyle;
    lala.titlesViewBackColor = [UIColor clearColor];
    lala.itemBackColor = [UIColor clearColor];
    lala.ItemWidthStyles = MJCItemAdaptiveWidthStyle;
    lala.itemMaxEdgeinsets = MJCEdgeInsetsMake(10,10,10,20,30);
    lala.itemTextSelectedColor = blackTitleColor;
    lala.itemTextNormalColor = QNDRGBColor(195, 195, 195);
    lala.itemTextFontSize = 16;
    lala.defaultShowItemCount = 3;
    lala.childsContainerBackColor = [UIColor whiteColor];
    lala.indicatorColor = blackTitleColor;
    lala.selectedSegmentIndex = _selectedIndex;
    [lala intoTitlesArray:titlesArr hostController:self];
    
    [self.view addSubview:lala];
    [lala intoChildControllerArray:VCArr];
}

- (void)mjc_ClickEvent:(UIButton *)tabItem childViewController:(UIViewController *)childViewController segmentInterface:(MJCSegmentInterface *)segmentInterface{
    WHLog(@"%ld",tabItem.tag);
    WHLog(@"%@",childViewController);
    WHLog(@"%@",segmentInterface);
}

-(void)WH_ClickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
