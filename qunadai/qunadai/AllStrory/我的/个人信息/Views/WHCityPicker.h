//
//  WHCityPicker.h
//  qunadai
//
//  Created by wang on 2017/4/20.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString * selectedStr);

@interface WHCityPicker : UIView

+(void)showPickerOnTheWindowAndSelecteBlcok:(SelectedBlock)selectedBlock;

@end
