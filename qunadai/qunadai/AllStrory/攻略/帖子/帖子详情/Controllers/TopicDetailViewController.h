//
//  TopicDetailViewController.h
//  qunadai
//
//  Created by wang on 2017/5/11.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopicMainModel.h"

@interface TopicDetailViewController : UIViewController

@property (strong,nonatomic)TopicMainModel * model;

@property (strong,nonatomic)NSString * topicId;

@end
