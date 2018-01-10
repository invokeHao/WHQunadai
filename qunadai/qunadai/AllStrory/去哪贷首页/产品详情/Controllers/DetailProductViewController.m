//
//  DetailProductViewController.m
//  qunadai
//
//  Created by wang on 17/4/5.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "DetailProductViewController.h"
#import "WangWebViewController.h"
#import "QNDProductCommentViewController.h"
#import "QNDProCommentDetailViewController.h"
#import "QNDFeedbackViewController.h"

#import "QNDDetailProTopTableViewCell.h"
#import "QNDDetailTextTableViewCell.h"
#import "QNDProductCommentTableViewCell.h"
#import "QNDNoCommentTableViewCell.h"

#import "WHTablePickerVIew.h"
#import "QNDProductReplyBar.h"

#import "QNDProductCommentListModel.h"

#import "ProductDetailApi.h"
#import "QNDProductCommetListApi.h"
#import "QNDApplicationOrderApi.h"
#import "QNDUserBrowsingHistoryApi.h"
#import "QNDProductPVCollectApi.h"


@interface DetailProductViewController ()<UITableViewDelegate,UITableViewDataSource,YTKChainRequestDelegate,ProReplyBarDelegate>
{
    NSMutableArray * verifyArr;
    UIButton * supplementBtn;//补充材料或者申请贷款按钮
    NSInteger selectRow;
    QNDProductCommentListModel * commentModel;
}

@property (strong,nonatomic)QNDProductReplyBar * replyBar;

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)NSMutableArray * commentArray;

@property (assign,nonatomic)int currentpage;

@property (assign,nonatomic)CGFloat history_Y_offset;

@property (assign,nonatomic)CGFloat seletedCellHeight;

@property (assign,nonatomic)CGFloat MarkOffset;

@end

@implementation DetailProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NOTIF_ADD(UIKeyboardWillChangeFrameNotification, keyboardWillChange:);
    [self layoutViews];
    [self setupRefresh];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"借款详情";
    [self setupRightNavightionBtn];
    [TalkingData trackPageBegin:_model.productName];
}
-(void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    //适配ios11上拉加载更多导致动画错乱
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 0, 34, 0);
        self.MainTable.estimatedRowHeight = 0;
        self.MainTable.estimatedSectionHeaderHeight = 0;
        self.MainTable.estimatedSectionFooterHeight = 0;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:_model.productName];
}

-(void)dealloc{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupRefresh{
    _currentpage = 1;
    @WHWeakObj(self);
    @WHStrongObj(self);
    self.MainTable.mj_header = [WHRefreshHeader headerWithRefreshingBlock:^{
        _currentpage = 1;
        [Strongself.commentArray removeAllObjects];
        [Strongself setupData];
    }];
    self.MainTable.mj_footer = [WHRefreshFooter footerWithRefreshingBlock:^{
        _currentpage++;
        [Strongself setupData];
    }];
}

-(void)setupRightNavightionBtn{
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"反馈问题" forState:UIControlStateNormal];
    [shareBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont:QNDFont(13.0)];
    [shareBtn setFrame:CGRectMake(0, 0, 65, 30)];
    [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -5)];
    [shareBtn addTarget:self action:@selector(pressToFeedBackTheProduction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * myItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    [self.navigationItem setRightBarButtonItem:myItem];
}


-(void)layoutViews{
    
    _MainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    _MainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _MainTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@-49);
    }];
    supplementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [supplementBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    [supplementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [supplementBtn setBackgroundColor:ThemeColor];
    [supplementBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [supplementBtn addTarget:self action:@selector(pressToSupplement:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:supplementBtn];
    
    [supplementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@49);
    }];
    
    _replyBar = [[QNDProductReplyBar alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 50)];
    _replyBar.delegate = self;
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 1)];
    lineView.backgroundColor = lightGrayBackColor;
    [_replyBar addSubview:lineView];
    [self.view addSubview:_replyBar];
}

#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        if (self.commentArray.count==0) {
            return 1;
        }
        return self.commentArray.count;
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


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 46;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        UIView * header = [self createHeaderViewWithTitle:@"用户评论" andhasComment:YES];
        return header;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 214;
    }else{
        if (self.commentArray.count>0) {
            QNDProductCommentListModel * model = self.commentArray[indexPath.row];
            return [model cellHeight];
        }else{
            return 155;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        QNDDetailProTopTableViewCell * topCell = [[QNDDetailProTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDDetailProTopTableViewCell"];
        [topCell setModel:self.model];
        return topCell;
    }else{
        if (self.commentArray.count>0) {
            QNDProductCommentTableViewCell * commentCell = [tableView dequeueReusableCellWithIdentifier:@"QNDProductCommentTableViewCell"] ;
            if (!commentCell) {
                commentCell = [[QNDProductCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDProductCommentTableViewCell"];
            }
            if (self.commentArray.count>0) {
                @WHWeakObj(self);
                @WHStrongObj(self);
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                commentCell.starView.hidden = YES;
                [commentCell setModel:self.commentArray[indexPath.row]];
                [commentCell setReplyB:^(NSString *cName, NSString *cId,UIButton * commentBtn) {
                   //点击评论
                    if (!KGetACCESSTOKEN) {
                        [[WHTool shareInstance]GoToLoginWithFromVC:self];
                        return;
                    }
                    commentModel = self.commentArray[indexPath.row];
                    Strongself.replyBar.pleaseholderLabel.text = cName;
                     Strongself.history_Y_offset = [commentBtn convertRect:commentBtn.bounds toView:window].origin.y;
                    QNDProductCommentListModel * replyModel = Strongself.commentArray[indexPath.row];
                     Strongself.seletedCellHeight =[replyModel cellHeight];
                    [Strongself.replyBar.inputText becomeFirstResponder];
                }];
                [commentCell setMoreB:^(QNDProductCommentListModel *model) {
                    QNDProCommentDetailViewController * detailVC = [[QNDProCommentDetailViewController alloc]init];
                    detailVC.commentModel = model;
                    [detailVC setSuccessBlock:^(QNDProductReplyListModel * model){
                        QNDProductCommentListModel * commentModel = Strongself.commentArray[indexPath.row];
                        commentModel.replyModel = model;
                        commentModel.replyNumber++;
                        [Strongself.MainTable reloadData];
                    }];
                    [Strongself.navigationController pushViewController:detailVC animated:YES];
                }];
            }
            return commentCell;
        }else{
            QNDNoCommentTableViewCell * NoCell = [[QNDNoCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDNoCommentTableViewCell"];
            return NoCell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}

-(UIView*)createHeaderViewWithTitle:(NSString*)title andhasComment:(BOOL)hasComment{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 36)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = QNDFont(16.0);
    titleLabel.textColor = black31TitleColor;
    titleLabel.text = title;
    [headerView addSubview:titleLabel];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = lightGrayBackColor;
    [headerView addSubview:lineView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"content_icon_review"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(PressToComment) forControlEvents:UIControlEventTouchUpInside];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.hidden = !hasComment;
    [headerView addSubview:button];

    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.mas_equalTo(headerView);
        make.height.equalTo(@14);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.mas_equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
    return headerView;
}

-(void)setupData{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    ProductDetailApi * api = [[ProductDetailApi alloc]initWithProductCode:_productCode];
    QNDProductCommetListApi * commentApi = [[QNDProductCommetListApi alloc]initWithProductId:_productId andPage:_currentpage];
    
    YTKChainRequest * chain = [[YTKChainRequest alloc]init];
    [chain addRequest:api callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        WHLog(@"%@",[baseRequest responseJSONObject]);
        NSDictionary * dic = [baseRequest responseJSONObject][@"data"];
        self.model = [[productLoanModel alloc]initWithDictionary:dic];
        [chainRequest addRequest:commentApi callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            WHLog(@"%@",baseRequest.responseJSONObject);
            NSInteger status = [[baseRequest responseJSONObject][@"status"]integerValue];
            if (status==1) {
                NSArray * sourceArr = [baseRequest responseJSONObject][@"data"][@"dataList"];
                for (NSDictionary * dic in sourceArr) {
                    QNDProductCommentListModel * model = [[QNDProductCommentListModel alloc]initWithDictionary:dic];
                    [self.commentArray addObject:model];
                    if (sourceArr.count<1&&_currentpage>1) {
                        _currentpage--;
                    }
                }
            }else{
                [self.view makeCenterToast:[baseRequest responseJSONObject][@"msg"]];
            }
        }];
    }];
    chain.delegate = self;
    [chain start];
    
    if (KGetACCESSTOKEN) {
     [self setupUserBrowsingWithProductId:_productId];
    }
}

#pragma mark-点击评论
-(void)PressToComment{
    if (!KGetACCESSTOKEN) {
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
        return;
    }
//    QNDFeedbackViewController * feedbackVC = [[QNDFeedbackViewController alloc]initWithFeedBackType:QNDCPLFeedbackType andProName:_model.productName];
//    [self.navigationController pushViewController:feedbackVC animated:YES];

//    QNDProductCommentViewController * commentVC = [[QNDProductCommentViewController alloc]init];
//    commentVC.productModel = self.model;
//
//    @WHWeakObj(self);
//    @WHStrongObj(self);
//    [commentVC setSuccessBlock:^{
//        [Strongself.commentArray removeAllObjects];
//        Strongself.currentpage = 0;
//        [Strongself setupData];
//    }];
//    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark- 点击回复
-(void)PostTheReplyWithContent:(NSString *)content{
    if (content.length<1) {
        return;
    }
//    QNDFeedbackViewController * feedbackVC = [[QNDFeedbackViewController alloc]initWithFeedBackType:QNDProFeedbackType andProName:_model.productName];
//    [self.navigationController pushViewController:feedbackVC animated:YES];

//    QNDProductReplyPostApi * api = [[QNDProductReplyPostApi alloc]initWithReplyId:commentModel.commentId andContent:content];
//    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        [self.replyBar.inputText resignFirstResponder];
//        QNDProductReplyListModel * model = [[QNDProductReplyListModel alloc]initWithDictionary:[request responseJSONObject][@"content"][@"newComment"]];
//        commentModel.replyModel = model;
//        commentModel.replyNumber++;
//        [self.MainTable reloadData];
//        [self.view makeCenterToast:@"回复成功"];
//        WHLog(@"%@",request.responseJSONObject);
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        WHLog(@"%@",request.error);
//    }];
}

#pragma mark-点击添加材料
-(void)pressToSupplement:(UIButton*)button{
    //判断如果未登录先去登录
    if (!KGetACCESSTOKEN) {
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
        return;
    }
    WangWebViewController * webVC = [[WangWebViewController alloc]init];
    webVC.webType = self.model.productName;
    webVC.url = self.model.productUrl;
    WHLog(@"url==%@",webVC.url);
    webVC.countStr = self.model.productName;
    webVC.isProduct = _needBack;
    @WHWeakObj(self);
    [webVC setBlock:^(NSString *pName) {
        [[WHTool shareInstance]showAlterViewWithMessage:FORMAT(@"您已经申请过(%@)了吗？",_model.productName) andDoneBlock:^(UIAlertAction * _Nonnull action) {
            [Weakself setupOrderTheApplicationWithProCode:_productCode];
        }];
    }];
    [self.navigationController pushViewController:webVC animated:YES];
    //立即申请pv统计
    [self setupThePVProductCollectWithType:QNDApplicateType];
}

- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    [[WHLoading ShareInstance]hidenHud];
    [[WHOopsView shareInstance]hidenTheOops];
    [self.MainTable.mj_header endRefreshing];
    [self.MainTable.mj_footer endRefreshing];
    [self.MainTable reloadData];
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    [self.MainTable.mj_header endRefreshing];
    [self.MainTable.mj_footer endRefreshing];
    if (request.responseStatusCode==0) {
        [[WHLoading ShareInstance]hidenHud];
        if (self.commentArray.count>0) {
            [self.commentArray removeAllObjects];
        }
        @WHWeakObj(self);
        [[WHOopsView shareInstance]showTheOopsViewOneTheView:self.view WithDoneBlock:^{
            [Weakself setupData];
        }];
    }
}
#pragma mark- 产品注册已经完成
-(void)setupOrderTheApplicationWithProCode:(NSString*)proCode{
    QNDApplicationOrderApi * api = [[QNDApplicationOrderApi alloc]initWithProCode:proCode];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        [self.MainTable reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}
#pragma mark -点击反馈问题
-(void)pressToFeedBackTheProduction{
    if (!KGetACCESSTOKEN) {
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
        return;
    }
//    QNDFeedbackViewController * feedbackVC = [[QNDFeedbackViewController alloc]initWithFeedBackType:QNDProFeedbackType andProName:_model.productName];
//    [self.navigationController pushViewController:feedbackVC animated:YES];
}

#pragma mark-PV统计
-(void)setupThePVProductCollectWithType:(WH_PVType)type{
    QNDProductPVCollectApi * api = [[QNDProductPVCollectApi alloc]initProductCode:_productCode andPVType:type];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [[request responseJSONObject][@"status"]integerValue];
        if (status!=1) {
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
        WHLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

#pragma mark- 记录产品浏览
-(void)setupUserBrowsingWithProductId:(NSString*)proId{
    QNDUserBrowsingHistoryApi * api = [[QNDUserBrowsingHistoryApi alloc]initWitnProId:proId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [[request responseJSONObject][@"status"]integerValue];
        if (status!=1) {
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
        WHLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

-(void)endEdit{
    [self.view endEditing:YES];
}

-(NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray arrayWithCapacity:0];
    }
    return  _commentArray;
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

#pragma mark- 键盘相关
- (void)keyboardWillChange:(NSNotification *)note{
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - ViewHeight-50;
    if (keyFrame.origin.y>ViewHeight-50) {
        moveY = keyFrame.origin.y-ViewHeight+self.replyBar.height;
    }
    WHLog(@"moveY===%f",moveY);
    if (moveY<0) {
        CGFloat delta = 0.0;
        delta = self.history_Y_offset + self.seletedCellHeight-35 - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyFrame.size.height-50-20);
        CGPoint offset = self.MainTable.contentOffset;
        offset.y += delta;
        if (offset.y < 0) {
            offset.y = 0;
        }
        if (self.MarkOffset==self.history_Y_offset) {
        }else{
            self.MarkOffset = self.history_Y_offset;
            [self.MainTable setContentOffset:offset animated:YES];
        }
    }
    [UIView animateWithDuration:duration animations:^{
        self.replyBar.transform=CGAffineTransformMakeTranslation(0, moveY);
    }];
}


@end
