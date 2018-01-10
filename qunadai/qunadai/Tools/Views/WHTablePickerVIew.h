//
//  WHTableVIew.h
//  qunadai
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WHTabelBlock)(NSString * selectedStr,NSInteger index);

@interface WHTablePickerView : UIView

+(void)showPickTableWithSouceArr:(NSArray*)sourceArr andSelectBlock:(WHTabelBlock)selectBlock;

@end
