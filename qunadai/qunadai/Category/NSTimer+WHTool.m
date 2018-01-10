//
//  NSTimer+WHTool.m
//  qunadai
//
//  Created by wang on 2017/7/24.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "NSTimer+WHTool.h"

@implementation NSTimer (WHTool)


+ (NSTimer *)WH_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval executeBlock:(WHExecuteTimerBlock)block repeats:(BOOL)repeats{
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(qs_executeTimer:) userInfo:[block copy] repeats:repeats];
    return timer;
}

+ (void)qs_executeTimer:(NSTimer *)timer{
    
    WHExecuteTimerBlock block = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
