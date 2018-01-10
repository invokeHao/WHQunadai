//
//  CPLProductDetailViewController.m
//  qunadai
//
//  Created by wang on 2017/11/3.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "CPLProductDetailViewController.h"
#import "WangWebViewController.h"
#import "CPLApplicationDetailViewController.h"
#import "WHJSWebViewController.h"
#import "QNDFeedbackViewController.h"

#import "CPLProDetailTopTableViewCell.h"
#import "CPLProDetailPickTableViewCell.h"
#import "CPLCreditsListCell.h"

#import "CPLUserCreditsListApi.h"
#import "CPLApplicationSubmitApi.h"
#import "CPLZhimaApi.h"
#import "QNDProductPVCollectApi.h"
#import "QNDCPLProDetailApi.h"
#import "QNDFuDataOperatorApi.h"
#import "QNDCreateOrderApi.h"

@interface CPLProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView * MainTable;

@property (strong,nonatomic)NSMutableArray * verifyArr;

@property (assign,nonatomic)CPLVerifyType cplType;
@end

@implementation CPLProductDetailViewController
{
    UIButton * supplementBtn;
    NSString * _valueStr;
    NSString * _dateStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
    //PV统计
    WH_PVType type = _model.isQND ? QNDCPLProType : CPLProductType;
    [self setupPVCollectWithType:type];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:FORMAT(@"CPL%@",_model.name)];
    self.title = self.model.name;
    [self setupData];
    [self setupRightNavightionBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:FORMAT(@"CPL%@",_model.name)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    _valueStr = FORMAT(@"%ld",self.model.max_amount);
    _dateStr =  FORMAT(@"%ld",self.model.max_duration);
    
    _MainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, CGFLOAT_MIN)];
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MainTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _MainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _MainTable.delegate = self;
    _MainTable.dataSource = self;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@-49);
    }];
    //适配ios11上拉加载更多导致动画错乱
    if (KIOS11Later) {
        self.MainTable.estimatedRowHeight = 0;
        self.MainTable.estimatedSectionHeaderHeight = 0;
        self.MainTable.estimatedSectionFooterHeight = 0;
    }
    
    supplementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [supplementBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    [supplementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [supplementBtn setBackgroundColor:QNDRGBColor(195, 195, 195)];
    [supplementBtn.titleLabel setFont:QNDFont(18.0)];
    supplementBtn.userInteractionEnabled = NO;
    [supplementBtn addTarget:self action:@selector(pressToSupplement:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:supplementBtn];
    
    [supplementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@49);
    }];
}

#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==3) {
        return self.model.credit_list.count;
    }else{
        return 1;
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
    if (section==0 || section==1) {
        return 0;
    }else{
        return 45;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==2){
        UIView * header = [self createHeaderViewWithTitle:@"利率说明"];
        return header;
    }else if (section==3){
        UIView * header = [self createHeaderViewWithTitle:@"材料认证"];
        return header;
    }else{
        return nil;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 152;
    }else if (indexPath.section==1){
        return 80;
    }else if (indexPath.section==2){
        if (self.model) {
            return [self.model textHeight];
        }else{
            return 24;
        }
    }else{
        return 52;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    if (indexPath.section==0) {
        CPLProDetailTopTableViewCell * topCell = [[CPLProDetailTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLProDetailTopTableViewCell"];
        [topCell setModel:self.model];
        return topCell;
    }else if (indexPath.section==1){
        CPLProDetailPickTableViewCell * pickCell = [[CPLProDetailPickTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLProDetailPickTableViewCell"];
        [pickCell setModel:self.model];
        [pickCell setValueB:^(NSString *valueStr) {
            _valueStr = valueStr;
        }];
        [pickCell setDateB:^(NSString *dateStr) {
            _dateStr = dateStr;
        }];
        return pickCell;
    }else if (indexPath.section==2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = QNDFont(14.0);
        cell.textLabel.textColor=QNDRGBColor(195, 195, 195);
        cell.textLabel.numberOfLines =0;
        if (self.model.requirement) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 4;// 字体的行间距
            NSDictionary *attributes = @{NSFontAttributeName : QNDFont(14.0),NSParagraphStyleAttributeName:paragraphStyle,};
            
            cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:self.model.requirement attributes:attributes];
        }
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@10);
            make.right.equalTo(@-12);
        }];
        return cell;
    }else{
        CPLCreditsListCell * creditsCell = [[CPLCreditsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPLCreditsListCell"];
        [creditsCell setModel:self.model.credit_list[indexPath.row]];
        return creditsCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==3) {
        CPLCreditListModel * model = self.model.credit_list[indexPath.row];
        if (model.credit_status == 2) {
            [self.view makeCenterToast:@"您已经认证成功"];
            return;
        }
        //检查当前点击前面的认证是否完成
        BOOL success = YES;
        for (int i =0 ; i<indexPath.row; i++) {
            CPLCreditListModel * listModel = self.model.credit_list[i];
            if (listModel.credit_status != 2) {
                success = NO;
            }
        }
        if (!success) {
            [self.view makeCenterToast:@"请按顺序完成认证"];
            return;
        }
        //手机信用认证
        if ([model.credit_code isEqualToString:@"mobile"]) {
            if (_model.isQND) {
                //获取运营商地址
                [self getTheFuDataUrl];
            }else{
                [TalkingData trackEvent:@"手机信用点击" label:@"手机信用点击"];
                WHJSWebViewController * jsWebVC = [[WHJSWebViewController alloc]init];
                jsWebVC.titleName = @"运营商认证";
#warning 上线需要修改地址
                jsWebVC.Url = FORMAT(@"%@#/authentification/mobile?token=%@&product_id=%@",WYBaseUrl,KGetCPLTOKEN,self.model.prId);
                self.cplType = CPLPhoneVerify;
                [self.navigationController pushViewController:jsWebVC animated:YES];
            }
        }
        else if ([model.credit_code isEqualToString:@"extra"]) {
            //附加信息
            [TalkingData trackEvent:@"附加信息点击" label:@"附加信息点击"];
            WHJSWebViewController * jsWebVC = [[WHJSWebViewController alloc]init];
            jsWebVC.titleName = @"附加信息";
            jsWebVC.Url = FORMAT(@"%@#/authentification/extra?token=%@&userId=%@&xtoken=%@",WYBaseUrl,KGetCPLTOKEN,KGetUserID,KGetACCESSTOKEN);
            self.cplType = CPLExtra1Verify;
            [self.navigationController pushViewController:jsWebVC animated:YES];
        }
        else if ([model.credit_code isEqualToString:@"extra2"]){
            //父母信息
            [TalkingData trackEvent:@"父母附加信息点击" label:@"父母附加信息点击"];
            WHJSWebViewController * jsWebVC = [[WHJSWebViewController alloc]init];
            jsWebVC.Url = FORMAT(@"%@#/authentification/parent?token=%@&userId=%@&xtoken=%@",WYBaseUrl,KGetCPLTOKEN,KGetUserID,KGetACCESSTOKEN);
            jsWebVC.titleName = @"父母信息";
            self.cplType = CPLEXtra2Verify;
            [self.navigationController pushViewController:jsWebVC animated:YES];
        }
        else if ([model.credit_code isEqualToString:@"zhimafen"]){
            [TalkingData trackEvent:@"芝麻信用点击" label:@"芝麻信用点击"];
            [self getTheZhimaUrl];
        }
    }
}

-(UIView*)createHeaderViewWithTitle:(NSString*)title{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = QNDFont(15.0);
    titleLabel.textColor = black31TitleColor;
    titleLabel.text = title;
    [headerView addSubview:titleLabel];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = lightGrayBackColor;
    [headerView addSubview:lineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.mas_equalTo(headerView);
        make.height.equalTo(@14);
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
    //如果为QND则重新拉去详情数据
    if (_model.isQND) {
        [self getQNDDataWithProCode:_model.prId];
    }else{
        //如果为CPL则拉取用户认证状态
        [self getCPLData];
    }
}

-(void)getQNDDataWithProCode:(NSString*)procode{
    QNDCPLProDetailApi * api = [[QNDCPLProDetailApi alloc]initWithProCode:procode];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            _model = [[CPLProductModel alloc]initWithDictionary:[request responseJSONObject][@"data"]];
            _model.isQND = YES;
            [self checkTheQNDVerify];
            [self.MainTable reloadData];
        }else{
            [self.view makeToast:[request responseJSONObject][@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

-(void)getCPLData{
    CPLUserCreditsListApi * api = [[CPLUserCreditsListApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSArray * sourceArr = [request responseJSONObject][@"data"];
        for (NSDictionary * dic in sourceArr) {
            CPLCreditListModel * model = [[CPLCreditListModel alloc]initWithDictionary:dic];
            [self.verifyArr addObject:model];
        }
        //碰撞得到认证状态
        [self checkTheVerifyList];
        [self.MainTable reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

-(void)getTheZhimaUrl{
    CPLZhimaApi * api = [[CPLZhimaApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSDictionary * sourceDic = [request responseJSONObject];
        if ([sourceDic[@"status_code"] integerValue] == 200) {
            NSString * url = sourceDic[@"data"][@"url"];
            WHJSWebViewController * jsWebVC = [[WHJSWebViewController alloc]init];
            jsWebVC.Url = url;
            jsWebVC.titleName = @"芝麻认证";
            self.cplType = CPLZhiMaVerify;
            [self.navigationController pushViewController:jsWebVC animated:YES];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

-(void)getTheFuDataUrl{
    QNDFuDataOperatorApi * api = [[QNDFuDataOperatorApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            [TalkingData trackEvent:@"手机信用点击" label:@"手机信用点击"];
            WHJSWebViewController * jsWebVC = [[WHJSWebViewController alloc]init];
            jsWebVC.titleName = @"运营商认证";
            jsWebVC.Url = [request responseJSONObject][@"data"][@"accessUrl"];
            self.cplType = CPLPhoneVerify;
            [self.navigationController pushViewController:jsWebVC animated:YES];
        }else{
            [self.view makeToast:[request responseJSONObject][@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
}

-(void)setupPVCollectWithType:(WH_PVType)type{
    QNDProductPVCollectApi * api = [[QNDProductPVCollectApi alloc]initProductCode:_model.prId andPVType:type];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

-(void)checkTheVerifyList{
    if (self.verifyArr.count>0&&self.model.credit_list.count>0) {
        for (CPLCreditListModel * model1 in self.model.credit_list) {
            for (CPLCreditListModel * model2 in self.verifyArr) {
                if ([model2.credit_code isEqualToString:model1.credit_code]) {
                    model1.credit_status = model2.credit_status;
                }
            }
        }
        BOOL isSuccess = YES;
        for (CPLCreditListModel * model in self.model.credit_list) {
            //埋点需求
            if (model.credit_status==2) {
                if ([model.credit_code isEqualToString:@"mobile"]&&_cplType == CPLPhoneVerify) {
                    [TalkingData trackEvent:@"手机信用完成" label:@"手机信用完成"];
                }
                else if ([model.credit_code isEqualToString:@"zhimafen"]&&_cplType == CPLZhiMaVerify){
                    [TalkingData trackEvent:@"芝麻信用完成" label:@"芝麻信用完成"];
                }else if ([model.credit_code isEqualToString:@"extra"]&&_cplType == CPLExtra1Verify){
                    [TalkingData trackEvent:@"附加信息完成" label:@"附加信息完成完成"];
                }else if([model.credit_code isEqualToString:@"extra2"]&& _cplType == CPLEXtra2Verify){
                    [TalkingData trackEvent:@"父母附加信息完成" label:@"父母附加信息完成完成"];
                }
            }
            
            if (model.credit_status != 2) {
                isSuccess = NO;
            }
        }
        if (isSuccess) {
            supplementBtn.backgroundColor = ThemeColor;
            supplementBtn.userInteractionEnabled = YES;
        }else{
            [supplementBtn setBackgroundColor:QNDRGBColor(195, 195, 195)];
            supplementBtn.userInteractionEnabled = NO;
        }
    }else{
        return;
    }
}

-(void)checkTheQNDVerify{
    CPLCreditListModel * CreditModel = [_model.credit_list firstObject];
    if (CreditModel.credit_status==2) {
        supplementBtn.backgroundColor = ThemeColor;
        supplementBtn.userInteractionEnabled = YES;
    }else{
        [supplementBtn setBackgroundColor:QNDRGBColor(195, 195, 195)];
        supplementBtn.userInteractionEnabled = NO;
    }
}

#pragma mark -点击反馈问题
-(void)pressToFeedBackTheProduction{
    QNDFeedbackType type =  _model.isQND ? QNDCPLFeedbackType : CPLProFeedbackType;
    QNDFeedbackViewController * feedbackVC = [[QNDFeedbackViewController alloc]initWithFeedBackType:type andProName:_model.name];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

#pragma mark- 点击申请
-(void)pressToSupplement:(UIButton*)button{
    [TalkingData trackEvent:@"CPL申请" label:@"CPL申请"];
    if (_model.isQND) {
        [self submitQndOrder];
    }else{
        [self submitCPLOrder];
    }
}

-(void)submitQndOrder{
    NSNumber * amountNum = [NSNumber numberWithInt:[_valueStr intValue]];
    NSNumber * dateNum = [NSNumber numberWithInt:[_dateStr intValue]];
    NSNumber * typeNUm = [NSNumber numberWithInt:(int)self.model.duration_type];
    NSDictionary * dic = @{@"userId" : KGetUserID, @"x-auth-token" : KGetACCESSTOKEN, @"productCode" : self.model.prId,@"request_amount" : amountNum,@"duration_number" : dateNum,@"duration_type" : typeNUm};

    QNDCreateOrderApi * api = [[QNDCreateOrderApi alloc]initWithPramDic:dic];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            CPLApplicationDetailViewController * applicationVC = [[CPLApplicationDetailViewController alloc]init];
            applicationVC.proModel = self.model;
            applicationVC.application_id = [request responseJSONObject][@"data"][@"application_id"];
            NOTIF_POST(KNOTIFICATION_APPLICATION, @YES);
            [self.navigationController pushViewController:applicationVC animated:YES];
        }else{
            [self.view makeToast:[request responseJSONObject][@"msg"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
    //提交pv统计
    [self setupPVCollectWithType:QNDCPLApplicateType];
}

-(void)submitCPLOrder{
    NSNumber * amountNum = [NSNumber numberWithInt:[_valueStr intValue]];
    NSNumber * dateNum = [NSNumber numberWithInt:[_dateStr intValue]];
    NSNumber * typeNUm = [NSNumber numberWithInt:(int)self.model.duration_type];
    NSDictionary * dic = @{@"app_id" : CPLAPPID, @"token" : KGetCPLTOKEN, @"product_id" : self.model.prId,@"request_amount" : amountNum,@"duration_number" : dateNum,@"duration_type" : typeNUm};
    //    WHLog(@"%@",dic);
    CPLApplicationSubmitApi * api = [[CPLApplicationSubmitApi alloc]initWithPramaDic:dic];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        NSDictionary * sourceDic = [request responseJSONObject];
        if ([sourceDic[@"status_code"] integerValue] == 200) {
            CPLApplicationDetailViewController * applicationVC = [[CPLApplicationDetailViewController alloc]init];
            applicationVC.proModel = self.model;
            NOTIF_POST(KNOTIFICATION_APPLICATION, @YES);
            [self.navigationController pushViewController:applicationVC animated:YES];
        }else{
            NSString * message = sourceDic[@"message"];
            [self.view makeToast:message];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.error);
    }];
    //提交pv统计
    [self setupPVCollectWithType:CPLApplicateType];
}

-(NSMutableArray *)verifyArr{
    if (!_verifyArr) {
        _verifyArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _verifyArr;
}

@end
