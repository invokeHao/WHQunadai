//
//  AccountViewController.m
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "AccountViewController.h"
#import "ConfirmNickNameViewController.h"

#import "AccountIconTableViewCell.h"
#import <Photos/Photos.h>
#import "UserAvatarModifyApi.h"

#import "AccountModel.h"
#import "QNDUserCountInfoApi.h"
#import "WHVerify.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray * titleArray;
}
@property (strong,nonatomic) UITableView * MainTable;

@property (strong,nonatomic) AccountModel * model;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self layoutViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //状态栏恢复默认设置
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"账号信息";
    [self setupData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 2;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0&&indexPath.row==0) {
        return 90;
    }else{
        return 44;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        AccountIconTableViewCell * accountCell = [[AccountIconTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountIconTableViewCell"];
        [accountCell.IconView sd_setImageWithURL:[NSURL URLWithString:_model.headUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        WHLog(@"avrtar==%@",_model.headUrl);
        accountCell.tag = 110;
        return accountCell;
    }else{
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MineFunctionTableViewCell"];
        cell.textLabel.text = titleArray[indexPath.row];
        cell.textLabel.font = QNDFont(14.0);
        cell.textLabel.textColor = black74TitleColor;
        cell.detailTextLabel.font= QNDFont(13.0);
        cell.detailTextLabel.textColor = defaultPlaceHolderColor;
        if (indexPath.row==0) {
            if ([WHVerify checkTelNumber:self.model.username]) {
                NSString*bStr = [self.model.username substringWithRange:NSMakeRange(3,4)];
                NSString * phone = [self.model.username stringByReplacingOccurrencesOfString:bStr withString:@"****"];
                cell.detailTextLabel.text = phone;
            }else{
                cell.detailTextLabel.text = self.model.username;
            }
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.model.mobile) {
                NSString*bStr = [self.model.mobile substringWithRange:NSMakeRange(3,4)];
                NSString * phone = [self.model.mobile stringByReplacingOccurrencesOfString:bStr withString:@"****"];
                cell.detailTextLabel.text = phone;
            }
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        //修改头像
        [self pickToUpDateTheIcon];
    }else if (indexPath.section==1&&indexPath.row ==0){
        //修改昵称
        ConfirmNickNameViewController * nicknameVC = [[ConfirmNickNameViewController alloc]init];
        nicknameVC.nickName = _model.username;
        [self.navigationController pushViewController:nicknameVC animated:YES];
    }
}

-(void)pickToUpDateTheIcon{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.view.tintColor =ThemeColor;
    picker.navigationBar.tintColor = ThemeColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTheActionSheetWithVC:picker];
    });
}

-(void)showTheActionSheetWithVC:(UIImagePickerController*)picker{
    @WHWeakObj(self);
    [[WHTool shareInstance] showActionSheetWithTitle1:@"相机" andTitle2:@"从相册中选择" withActionBlock1:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == AVAuthorizationStatusDenied) {
                [Weakself openThePrivacyWithTitle:@"没有相机权限，是否去设置权限"];
            }else{
                [Weakself presentViewController:picker animated:YES completion:NULL];
            }
        }];
    } andActionBlock2:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status==PHAuthorizationStatusDenied) {
                [Weakself openThePrivacyWithTitle:@"没有相册权限，是否去设置权限"];
            }else{
                [Weakself presentViewController:picker animated:YES completion:NULL];
            }
        }];
    }];
}

#pragma pickerView的代理方法

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    @WHWeakObj(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage*iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
            [picker dismissViewControllerAnimated:YES completion:^{}];
            //头像同步修改,需做保存本地处理,或上传
            [Weakself uploadAvatarWithImage:iconImage];
        });
    });
}


-(void)openThePrivacyWithTitle:(NSString*)title{
    [[WHTool shareInstance]showAlterViewWithMessage:title andDoneBlock:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
            [[UIApplication sharedApplication] openURL:settingUrl];
        }
    }];
}

#pragma  mark- 上传头像
-(void)uploadAvatarWithImage:(UIImage *)image{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    UserAvatarModifyApi * api = [[UserAvatarModifyApi alloc]initWithimage:image];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"success==%@",[request responseJSONObject]);
        [self setupData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"failure==%@",[request responseJSONObject]);
        [[WHLoading ShareInstance]hidenHud];
    }];
}

-(void)setupData{
    QNDUserCountInfoApi * api = [[QNDUserCountInfoApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        WHLog(@"%@",request.responseJSONObject);
        [[WHLoading ShareInstance]hidenHud];
        [[WHOopsView shareInstance]hidenTheOops];
        
        NSDictionary * dataDic = [request responseJSONObject][@"data"];
        NSInteger status = [[request responseJSONObject][@"status"] integerValue];
        if (status==1) {
            _model = [[AccountModel alloc]initWithDictionary:dataDic];
        }else{
            [self.view makeCenterToast:[request responseJSONObject][@"msg"]];
        }
        [self.MainTable reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseStatusCode==0) {
            [[WHLoading ShareInstance]hidenHud];
            @WHWeakObj(self);
            [[WHOopsView shareInstance]showTheOopsViewOneTheView:self.view WithDoneBlock:^{
                [Weakself setupData];
            }];
        }
    }];
}

-(void)setData{
    titleArray = @[@"昵称",@"手机号"];
}
@end
