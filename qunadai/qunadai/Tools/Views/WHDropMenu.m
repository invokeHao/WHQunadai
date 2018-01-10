//
//  WHDropMenu.m
//  qunadai
//
//  Created by wang on 17/4/6.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

@interface WHDropMenuCell : UITableViewCell

@property (strong,nonatomic)UIImageView * selectImageV;
@property (strong,nonatomic)UILabel * titleLabel;

-(void)setTitleLabel:(UILabel *)titleLabel;

@end

@implementation WHDropMenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews{
    _selectImageV = [[UIImageView alloc]init];
    _selectImageV.image = [UIImage imageNamed:@"duihao"];
    _selectImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_selectImageV];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = QNDFont(13.0);
    _titleLabel.textColor = blackTitleColor;
    [self.contentView addSubview:_titleLabel];
    
    [_selectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_selectImageV.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.height.equalTo(@14);
    }];
}

-(void)setTitleLabel:(UILabel *)titleLabel{
    _titleLabel =titleLabel;
}

@end


#import "WHDropMenu.h"

#define KWHTablePickDuration 0.3


@interface WHDropMenu ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * WHtableView;
    CGFloat KWHTableViewH;
    UIView * pickView;//选择的view
    UILabel * titleLabel;
}

@property (strong,nonatomic)selectBlock selectB;

@property (strong,nonatomic)NSArray * dataArray;//数据源


@end

@implementation WHDropMenu

+(void)showPickTableWithSouceArr:(NSArray*)sourceArr andSelectBlock:(selectBlock)selectBlock{
    WHDropMenu * menu = [[WHDropMenu alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    menu.dataArray = sourceArr;
    menu.selectB = selectBlock;
    [menu initViews];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:menu];
    [menu show];
 
}

-(instancetype)initWithFrame:(CGRect)frame AndDataSource:(NSArray *)arr andSelectBlock:(selectBlock)selectBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = arr;
        self.selectB = selectBlock;
        [self initViews];
    }
    return self;
}

-(void)initViews{

    [self createPickView];
    
    KWHTableViewH = 44*_dataArray.count;
    if (_dataArray.count>7) {
        KWHTableViewH = 44*7;
    }
    WHtableView = [[UITableView alloc]initWithFrame:CGRectMake(-70, -KWHTableViewH, ViewWidth,  KWHTableViewH)];
    WHtableView.backgroundColor = grayBackgroundLightColor;
    WHtableView.separatorColor = lightGrayBackColor;
    WHtableView.separatorInset = UIEdgeInsetsZero;
    WHtableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    WHtableView.delegate = self;
    WHtableView.dataSource = self;
    [self addSubview:WHtableView];
}

-(void)createPickView{
    pickView = [[UIView alloc]initWithFrame:self.bounds];
    pickView.backgroundColor = [UIColor whiteColor];
    [self addSubview:pickView];
    
    CGFloat itemWidth = self.width/3;
    UIButton * firstBtn = [self creatBtnWithFrame:CGRectMake(0, 0, itemWidth, self.height) andTitle:@"职业身份"];
    UIButton * secondBtn = [self creatBtnWithFrame:CGRectMake(itemWidth, 0, itemWidth, self.height) andTitle:@"贷款额度"];
    UIButton * thirdBtn = [self creatBtnWithFrame:CGRectMake(itemWidth*2, 0, itemWidth, self.height) andTitle:@"贷款期限"];
    
    [pickView addSubview:firstBtn];
    [pickView addSubview:secondBtn];
    [pickView addSubview:thirdBtn];
    
}

-(UIButton*)creatBtnWithFrame:(CGRect)frame andTitle:(NSString*)title{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:blackTitleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:QNDFont(14.0)];
    [button addTarget:self action:@selector(pressTheSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)pressTheSelectedBtn:(UIButton*)button{
    [self show];
}



#pragma mark-tableView的代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WHDropMenuCell * cell = [tableView dequeueReusableCellWithIdentifier: @"WHDropMenuCell"];
    if (cell==nil) {
        cell = [[WHDropMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"WHDropMenuCell"];
    }
    [cell.titleLabel setText:_dataArray[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        NSString * selectStr = _dataArray[indexPath.row];
        _selectB(selectStr);
    }
    [self dismiss];
}

#pragma mark - dismiss

-(void)tapToDismiss:(UITapGestureRecognizer*)tap{
    if (self) {
        [self dismiss];
    }
}


-(void)dismiss{
    CGRect tableRect = WHtableView.frame;
    tableRect.origin.y = -KWHTableViewH;
    [UIView animateWithDuration:KWHTablePickDuration animations:^{
        WHtableView.frame = tableRect;
        self.backgroundColor= [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show{
    CGRect tableRect = WHtableView.frame;
    tableRect.origin.y = 40;
    [UIView animateWithDuration:KWHTablePickDuration animations:^{
        WHtableView.frame = tableRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
    
    //添加手势
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(-70, CGRectGetMaxY(WHtableView.frame)+10, ViewWidth, ViewHeight- WHtableView.height-64-40)];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToDismiss:)];
    [backView addGestureRecognizer:tap];

  
}

@end
