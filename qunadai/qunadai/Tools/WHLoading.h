//
//  WHLoading.h
//  qunadai
//
//  Created by wang on 17/4/14.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHLoading : NSObject

+(WHLoading *) ShareInstance;


-(void)showImageHUD:(UIView*)view;

-(void)hidenHud;

-(BOOL)isShowingHud;

@end
