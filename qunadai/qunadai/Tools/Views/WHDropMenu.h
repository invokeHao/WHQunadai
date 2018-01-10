//
//  WHDropMenu.h
//  qunadai
//
//  Created by wang on 17/4/6.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSString * selectStr);

@interface WHDropMenu : UIView

+(void)showPickTableWithSouceArr:(NSArray*)sourceArr andSelectBlock:(selectBlock)selectBlock;

-(instancetype)initWithFrame:(CGRect)frame AndDataSource:(NSArray*)arr andSelectBlock:(selectBlock)selectBlock;

@end
