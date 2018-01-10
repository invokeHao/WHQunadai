//
//  MineSettingViewController.m
//  qunadai
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "MineSettingViewController.h"
#import "AboutUsViewController.h"
#import "SZKCleanCache.h"
#import "QNDLoginViewController.h"

#define filePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@interface MineSettingViewController ()
{
    NSArray * titleArray;
}
@property (strong,nonatomic)UITableView * MainTable;


@end

@implementation MineSettingViewController

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
    self.title =@"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)layoutViews{
    _MainTable = [[UITableView alloc]init];
    _MainTable = [[UITableView alloc]init];
    _MainTable.backgroundColor = grayBackgroundLightColor;
    _MainTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _MainTable.separatorColor = lightGrayBackColor;
    _MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _MainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    __weak id weakSelf = self;
    _MainTable.delegate = weakSelf;
    _MainTable.dataSource = weakSelf;
    [self.view addSubview:_MainTable];
    [_MainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

#pragma mark-tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 2;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingCell"];
    cell.textLabel.font = QNDFont(14.0);
    cell.textLabel.textColor = blackTitleColor;
    cell.textLabel.text = titleArray[indexPath.section*2+indexPath.row];
    
    cell.detailTextLabel.font = QNDFont(14.0);
    
    UIImageView * moreView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 16)];
    [moreView setImage:[UIImage imageNamed:@"goin"]];
    [moreView setContentMode:UIViewContentModeScaleAspectFit];
    
    cell.accessoryView = moreView;
    if (indexPath.section == 0 && indexPath.row==1){
        NSString *fileSize = [NSString stringWithFormat:@"%.1fM",[SZKCleanCache folderSizeAtPath]];
        cell.detailTextLabel.textColor =ThemeColor;
        cell.detailTextLabel.text = fileSize;
    }else if(indexPath.section ==1 &&indexPath.row ==1){
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        cell.accessoryView.hidden=YES;
        cell.detailTextLabel.textColor = blackTitleColor;
        NSString * verson=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString * verSonStr = [NSString stringWithFormat:@"V%@",verson];
        cell.detailTextLabel.text = verSonStr;
        [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@10);
            make.centerY.mas_equalTo(cell.contentView);
            make.height.equalTo(@15);
        }];
    }else if (indexPath.section==2){
        cell.accessoryView.hidden =YES;
        UILabel * exitLabel = [[UILabel alloc]init];
        exitLabel.text = @"退出登录";
        exitLabel.font = QNDFont(14.0);
        exitLabel.textColor = ThemeColor;
        [cell addSubview:exitLabel];
        [exitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(cell);
            make.centerY.mas_equalTo(cell);
            make.height.equalTo(@15);
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
        //给个好评
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", APPStoreId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (indexPath.section ==0&&indexPath.row==1){
        //清除缓存
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定清除缓存吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //创建一个取消和一个确定按钮
        UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
        
        __weak typeof(self) weakSelf = self;
        __strong typeof(self)strongSelf = weakSelf;
        UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [SZKCleanCache cleanCache:^{
                [strongSelf.MainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [strongSelf.view makeCenterToast:@"清除成功"];
            }];
        }];
        //将取消和确定按钮添加进弹框控制器
        [alert addAction:actionCancle];
        [alert addAction:actionOk];
        //添加一个文本框到弹框控制器
        //显示弹框控制器
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (indexPath.section==1&&indexPath.row==0) {
        //关于我们
        AboutUsViewController * aboutVC = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    else if(indexPath.section==2){
        //退出登录
        [self cleanTheCache];
        [[WHTool shareInstance]GoToLoginWithFromVC:self];
    }
}

-(void)setData{
    titleArray = @[@"给个好评",@"清除缓存",@"关于我们",@"版本号",@""];
}

-(void)cleanTheCache{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUserToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUserPhoneNum];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CPLUserToken];
    NOTIF_POST(KNOTIFICATION_LOGOUT, @YES);
}


@end
