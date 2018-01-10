//
//  QNDBankListTableViewController.m
//  qunadai
//
//  Created by wang on 2017/9/26.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

#import "QNDBankListTableViewController.h"

#import "QNDBankListTableViewCell.h"

@interface QNDBankListTableViewController ()

@end

@implementation QNDBankListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = grayBackgroundLightColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"银行卡";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QNDBankListTableViewCell * cell = [[QNDBankListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QNDBankListTableViewCell"];
    cell.nameLabel.text = _bankName;
    [cell setNumberLabelWithBankNum:_bankNum];
    return cell;
}


@end
