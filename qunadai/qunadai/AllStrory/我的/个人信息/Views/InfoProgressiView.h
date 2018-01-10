//
//  InfoProgressiView.h
//  qunadai
//
//  Created by wang on 17/4/10.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoProgressiView : UIView

@property (strong,nonatomic) UIColor * finishColor;


-(instancetype)initWithFinishColor:(UIColor*)finish andFrame:(CGRect)frame andTitle:(NSString*)title;


@end
