//
//  QNDProductCommentViewController.m
//  qunadai
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "QNDProductCommentViewController.h"
#import "QNDProductCommentPostApi.h"
#import "WHStarView.h"

@interface QNDProductCommentViewController ()<UIScrollViewDelegate,UITextViewDelegate>

@property (strong,nonatomic)UIScrollView * mainScroller;

@property (strong,nonatomic)WHStarsView * starView;

@property (strong,nonatomic)UITextView * commentText;//评论框

@property (strong,nonatomic)UIButton * postBtn;

@end

@implementation QNDProductCommentViewController
{
    NSInteger _score;
    UILabel * contentPleaseHolder;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NOTIF_ADD(UITextViewTextDidChangeNotification, textViewDidChanged:);
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"添加评论";
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:UIKeyboardWillChangeFrameNotification];
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutViews{
    _score = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mainScroller = [[UIScrollView alloc]init];
    [_mainScroller setFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64)];
    _mainScroller.backgroundColor = grayBackgroundLightColor;
    _mainScroller.showsVerticalScrollIndicator = NO;
    _mainScroller.contentSize = CGSizeMake(ViewWidth, ViewHeight-64+1);
    _mainScroller.delegate = self;
    [self.view addSubview:_mainScroller];
    
    UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 26, 26)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:_productModel.productLogoUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
    [_mainScroller addSubview:iconView];
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.font = QNDFont(14.0);
    nameLabel.textColor = black74TitleColor;
    nameLabel.text = _productModel.productName;
    [_mainScroller addSubview:nameLabel];
    
    //星星
    _starView = [[WHStarsView alloc]initWithStarSize:CGSizeMake(26, 26) margin:10 numberOfStars:5];
    [_starView setBounds:CGRectMake(0, 0, 170, 26)];
    [_starView setCenter:CGPointMake(ViewWidth/2, iconView.center.y+60)];
    _starView.allowSelect = YES;  // 默认可点击
    _starView.allowDecimal = NO;  //默认可显示小数
    _starView.allowDragSelect = YES;//默认不可拖动评分，可拖动下需可点击才有效
    _starView.score = 0;
    _starView.touchedActionBlock = ^(CGFloat score) {
        _score = (NSInteger)score;
    };
    [_mainScroller addSubview:_starView];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_starView.frame)+45, ViewWidth-24, 120)];
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
    backView.backgroundColor = QNDRGBColor(230, 230, 230);
    [_mainScroller addSubview:backView];
    
    _commentText = [[UITextView alloc]initWithFrame:CGRectMake(12, 12, backView.width-24, 100)];
    _commentText.font = QNDFont(14.0);
    _commentText.tintColor = ThemeColor;
    _commentText.textColor = black74TitleColor;
    _commentText.backgroundColor = QNDRGBColor(230, 230, 230);
    _commentText.delegate = self;
    [backView addSubview:self.commentText];
    
    contentPleaseHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 230, 20)];
    contentPleaseHolder.font = QNDFont(14.0);
    contentPleaseHolder.textColor = defaultPlaceHolderColor;
    contentPleaseHolder.text = @"请填写您的评论，字数不能超过100";
    [_commentText addSubview:contentPleaseHolder];
    
    [self.postBtn setFrame:CGRectMake(ViewWidth-12-60, CGRectGetMaxY(backView.frame)+10, 60, 28)];
    [self.mainScroller addSubview:self.postBtn];
                              
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView.mas_right).with.offset(5);
        make.top.equalTo(@15);
        make.height.equalTo(@15);
    }];
}


#pragma mark- UIScrollView delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark-UITextView delegate

-(void)textViewDidChanged:(NSNotification*)notification{
    contentPleaseHolder.hidden = _commentText.text.length>0 ? YES : NO;
    
    if (_commentText.text.length>100) {
        [self.view makeCenterToast:@"超过100字啦"];
    }
}

-(void)pressToPostTheComment{
    if (_score<1) {
        [self.view makeCenterToast:@"请先做出评分"];
        return;
    }
    if (_commentText.text.length<1) {
        [self.view makeCenterToast:@"请不要发送空内容"];
        return;
    }
    if (_commentText.text.length>100) {
        [self.view makeCenterToast:@"字数超过100字啦"];
        return;
    }
    NSDictionary * pramaDic = @{@"content": _commentText.text,@"stars" : FORMAT(@"%ld",_score)};
    QNDProductCommentPostApi * api = [[QNDProductCommentPostApi alloc]initWithProductId:_productModel.productCode andPramaDic:pramaDic];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        self.SuccessBlock();
        [self.navigationController popViewControllerAnimated:YES];
        [self.parentViewController.view makeCenterToast:@"评论成功"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

-(UIButton *)postBtn{
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_postBtn.titleLabel setFont:QNDFont(14)];
        [_postBtn setBackgroundColor:ThemeColor];
        [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postBtn addTarget:self action:@selector(pressToPostTheComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

@end
