//
//  WHCityPicker.m
//  qunadai
//
//  Created by wang on 2017/4/20.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#define KCityPickerH  300
#define KTopHeight 45
#define KWHPickDuration 0.3

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

#import "WHCityPicker.h"

@interface WHCityPicker()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    UIView * visibleView;//tableview下方的view
    
    NSString *selectedProvince;
}

@property (strong,nonatomic)SelectedBlock selectedB;

@property (strong,nonatomic)UIPickerView * cityPicker;

@end

@implementation WHCityPicker


+(void)showPickerOnTheWindowAndSelecteBlcok:(SelectedBlock)selectedBlock{
    WHCityPicker * picker = [[WHCityPicker alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    picker.selectedB = selectedBlock;
    [picker layoutViews];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:picker];
    [picker show];
}

-(void)show{
    CGRect tableRect = visibleView.frame;
    tableRect.origin.y = ViewHeight - visibleView.height;
    [UIView animateWithDuration:KWHPickDuration animations:^{
        visibleView.frame = tableRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
}

-(void)dismiss{
    CGRect tableRect = visibleView.frame;
    tableRect.origin.y = ViewHeight;
    [UIView animateWithDuration:KWHPickDuration animations:^{
        visibleView.frame = tableRect;
        self.backgroundColor= [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)setData{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
}

-(void)layoutViews{
    
    [self setData];
    
    visibleView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, KCityPickerH)];
    visibleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:visibleView];
    
    UIButton *cancelChooseButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    [cancelChooseButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelChooseButton setTitleColor:ThemeColor forState:UIControlStateNormal];
    [cancelChooseButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [visibleView addSubview:cancelChooseButton];
    UIButton *confirmChooseButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth-10-60, 10, 60, 30)];
    [confirmChooseButton setTitle:NSLocalizedString(@"确定", @"") forState:UIControlStateNormal];
    [confirmChooseButton setTitleColor:ThemeColor forState:UIControlStateNormal];
    [confirmChooseButton addTarget:self action:@selector(confirmSelected:) forControlEvents:UIControlEventTouchUpInside];
    [visibleView addSubview:confirmChooseButton];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 45, ViewWidth, 0.5)];
    line.backgroundColor = lightGrayBackColor;
    [visibleView addSubview:line];
    
    _cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(15, KTopHeight, ViewWidth-30, KCityPickerH-KTopHeight)];
    _cityPicker.delegate = self;
    _cityPicker.dataSource = self;
    [visibleView addSubview:_cityPicker];
    
    //添加手势
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight- KCityPickerH)];
    backView.backgroundColor = [UIColor clearColor];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];
}

-(void)confirmSelected:(UIButton*)button{
    NSInteger provinceIndex = [_cityPicker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [_cityPicker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [_cityPicker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    NSString *showMsg = [NSString stringWithFormat: @"%@,%@,%@", provinceStr, cityStr, districtStr];
    
    _selectedB(showMsg);
    [self dismiss];
}

#pragma mark- picker的代理

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        city = [[NSArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [_cityPicker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [_cityPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_cityPicker reloadComponent: CITY_COMPONENT];
        [_cityPicker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else {
                return (NSComparisonResult)NSOrderedAscending;
            }
//            return (NSComparisonResult)NSOrderedSame;
        }];
        if (sortedArray.count<1) {
            return;
        }
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
    
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [_cityPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_cityPicker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}


@end
