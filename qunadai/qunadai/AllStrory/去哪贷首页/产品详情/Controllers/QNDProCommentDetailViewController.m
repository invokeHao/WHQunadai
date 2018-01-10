//
//  QNDProCommentDetailViewController.m
//  qunadai
//
//  Created by wang on 2017/10/9.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDProCommentDetailViewController.h"

#import "QNDProductReplyListApi.h"
#import "QNDProductReplyBar.h"

#import "QNDProductCommentTableViewCell.h"
#import "QNDProReplyListTableViewCell.h"
#import "QNDProductReplyPostApi.h"

@interface QNDProCommentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ProReplyBarDelegate>

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)QNDProductReplyBar * replyBar;

@property (strong,nonatomic)NSMutableArray * dataArray;

@property (assign,nonatomic)int currentpage;
@end

@implementation QNDProCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NOTIF_ADD(UIKeyboardWillChangeFrameNotification, keyboardWillChange:);
    [self setupData];
    [self layoutViews];
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"评论";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } @catch (NSException *exception) {
    } @finally {
    }
}

-(void)setupRefresh{
    _currentpage = 0;
    @WHWeakObj(self);
    @WHStrongObj(self);
    self.MainTable.mj_header = [WHRefreshHeader headerWithRefreshingBlock:^{
        _currentpage = 0;
        [Strongself.dataArray removeAllObjects];
        [Strongself setupData];
    }];
    self.MainTable.mj_footer = [WHRefreshFooter footerWithRefreshingBlock:^{
        _currentpage++;
        [Strongself setupData];
    }];
}


-(void)layoutViews{
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.001)];
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    _MainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    if (KIOS11Later) {
        _MainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _MainTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _MainTable.scrollIndicatorInsets = _MainTable.contentInset;
        self.MainTable.estimatedRowHeight = 0;
        self.MainTable.estimatedSectionHeaderHeight = 0;
        self.MainTable.estimatedSectionFooterHeight = 0;
    }
    _replyBar = [[QNDProductReplyBar alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 50)];
    _replyBar.delegate = self;
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 1)];
    lineView.backgroundColor = lightGrayBackColor;
    [_replyBar addSubview:lineView];
    [self.view addSubview:_replyBar];
}

#pragma mark-tableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return self.commentModel.cellHeight;
    }else{
        QNDProductReplyListModel * replyModel = self.dataArray[indexPath.row-1];
        return [replyModel cell_height];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        QNDProductCommentTableViewCell * commentCell = [[QNDProductCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDProductCommentTableViewCell"];
        commentCell.starView.hidden = YES;
        commentCell.lineView.hidden = YES;
        [commentCell setModel:self.commentModel];
        @WHWeakObj(self);
        @WHStrongObj(self);
        [commentCell setReplyB:^(NSString *cName, NSString *cId, UIButton *commentBtn) {
            if (!KGetACCESSTOKEN) {
                [[WHTool shareInstance]GoToLoginWithFromVC:self];
                return;
            }
            Strongself.replyBar.pleaseholderLabel.text = FORMAT(@"回复 %@",cName);
            [Strongself.replyBar.inputText becomeFirstResponder];
        }];
        return commentCell;
        
    }else{
        QNDProReplyListTableViewCell * replyCell = [tableView dequeueReusableCellWithIdentifier:@"QNDProReplyListTableViewCell"];
        if (!replyCell) {
            replyCell = [[QNDProReplyListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDProReplyListTableViewCell"];
        }
        if (self.dataArray.count>0) {
            QNDProductReplyListModel * replyModel = self.dataArray[indexPath.row-1];
            [replyCell setModel:replyModel];
        }
        return replyCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setupData{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    QNDProductReplyListApi * api = [[QNDProductReplyListApi alloc]initWithCommentId:self.commentModel.commentId andPage:_currentpage];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[WHLoading ShareInstance]hidenHud];
        WHLog(@"%@",request.responseJSONObject);
        NSArray * sourceArr = [request responseJSONObject][@"content"][@"replies"][@"content"];
        for (NSDictionary * dic in sourceArr) {
            QNDProductReplyListModel * model = [[QNDProductReplyListModel alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
            [self.MainTable reloadData];
            if (sourceArr.count==0&&_currentpage>0) {
                _currentpage--;
            }
        }
        [[WHOopsView shareInstance]hidenTheOops];
        [self.MainTable.mj_header endRefreshing];
        [self.MainTable.mj_footer endRefreshing];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
        [self.MainTable.mj_header endRefreshing];
        [self.MainTable.mj_footer endRefreshing];
        if (request.responseStatusCode==0) {
            [[WHLoading ShareInstance]hidenHud];
            if (self.dataArray.count>0) {
                [self.dataArray removeAllObjects];
            }
            @WHWeakObj(self);
            [[WHOopsView shareInstance]showTheOopsViewOneTheView:self.view WithDoneBlock:^{
                [Weakself setupData];
            }];
        }
    }];
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

#pragma mark- 点击回复
-(void)PostTheReplyWithContent:(NSString *)content{
    if (content.length<1) {
        return;
    }
    QNDProductReplyPostApi * api = [[QNDProductReplyPostApi alloc]initWithReplyId:self.commentModel.commentId andContent:content];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.replyBar.inputText resignFirstResponder];
        [self.dataArray removeAllObjects];
        [self setupData];
        QNDProductReplyListModel * replyModel = [[QNDProductReplyListModel alloc]initWithDictionary:[request responseJSONObject][@"content"][@"newComment"]];
        _successBlock(replyModel);
        [self.view makeCenterToast:@"回复成功"];
        WHLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}
//#pragma mark-键盘相关
- (void)keyboardWillChange:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];

    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - ViewHeight-50;
    if (keyFrame.origin.y>ViewHeight) {
        moveY = keyFrame.origin.y-ViewHeight;
    }
    WHLog(@"moveF==%f",moveY);
    [UIView animateWithDuration:duration animations:^{
        self.replyBar.transform=CGAffineTransformMakeTranslation(0, moveY);
    }];
}

@end
