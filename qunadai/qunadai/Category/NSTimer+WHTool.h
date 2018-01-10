//
//  NSTimer+WHTool.h
//  qunadai
//
//  Created by wang on 2017/7/24.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WHExecuteTimerBlock) (NSTimer *timer);


@interface NSTimer (WHTool)
//这个分类只要是为了解决timer导致的循环引用

+ (NSTimer *)WH_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval executeBlock:(WHExecuteTimerBlock)block repeats:(BOOL)repeats;


@end
