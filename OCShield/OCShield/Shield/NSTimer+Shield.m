//
//  NSTimer+Shield.m
//  OCShield
//
//  Created by william on 2019/12/13.
//  Copyright © 2019 william. All rights reserved.
//

#import "NSTimer+Shield.h"
#import "ShieldHelper.h"

@interface ShieldTimer : NSObject

// 目标
@property(nonatomic, weak) id target;
// 信息
@property(nonatomic, assign) id userInfo;
// 方法
@property(nonatomic, assign) SEL selector;
// 定时器
@property(nonatomic, weak) NSTimer *timer;

@property(nonatomic, copy) NSString *targetClassName;

@property(nonatomic, copy) NSString *targetSelectorName;

@property(nonatomic, assign) NSTimeInterval timeInterval;

@end

@implementation ShieldTimer

- (void)fireTimer
{
    if (!self.target) {
        [self.timer invalidate];
        self.timer = nil;

        NSLog(@"------ 定时器没有target错误 ------");
        
        return;
    }
    
    if ([self.target respondsToSelector:self.selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.timer];
        #pragma clang diagnostic pop
    }
}

- (void)dealloc
{
    NSLog(@"------ ShieldTimer dealloc ------");
}

@end

@implementation NSTimer (Shield)

#pragma mark - Public Api
/*
 防止定时器无法释放销毁引起崩溃
*/
+ (void)shield_interceptTimerAllCrash
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [ShieldHelper shield_swizzleClassMethodForClass:[NSTimer class] originalSelector:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:) swizzlingSelector:@selector(shield_timerWithTimeInterval:target:selector:userInfo:repeats:)];
        
        [ShieldHelper shield_swizzleClassMethodForClass:[NSTimer class] originalSelector:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) swizzlingSelector:@selector(shield_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];

    });
}

#pragma mark - Private Api

+ (NSTimer *)shield_timerWithTimeInterval:(NSTimeInterval)ti target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats
{
    if (!repeats) {
        return [NSTimer shield_timerWithTimeInterval:ti target:target selector:selector userInfo:userInfo repeats:repeats];
    }
    
    ShieldTimer *subTarget = [[ShieldTimer alloc]init];
    subTarget.target = target;
    subTarget.userInfo = userInfo;
    subTarget.selector = selector;
    subTarget.timeInterval = ti;
    subTarget.targetClassName = [NSString stringWithCString:object_getClassName(target) encoding:NSASCIIStringEncoding];
    subTarget.targetSelectorName = NSStringFromSelector(selector);
    
    NSTimer *timer = [NSTimer shield_timerWithTimeInterval:ti target:subTarget selector:@selector(fireTimer) userInfo:userInfo repeats:repeats];
    subTarget.timer = timer;
    return timer;
}

+ (NSTimer *)shield_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats
{
    if (!repeats) {
        return [NSTimer shield_timerWithTimeInterval:ti target:target selector:selector userInfo:userInfo repeats:repeats];
    }
    
    ShieldTimer *subTarget = [[ShieldTimer alloc]init];
    subTarget.target = target;
    subTarget.userInfo = userInfo;
    subTarget.selector = selector;
    subTarget.timeInterval = ti;
    subTarget.targetClassName = [NSString stringWithCString:object_getClassName(target) encoding:NSASCIIStringEncoding];
    subTarget.targetSelectorName = NSStringFromSelector(selector);
    
    NSTimer *timer = [NSTimer shield_timerWithTimeInterval:ti target:subTarget selector:@selector(fireTimer) userInfo:userInfo repeats:repeats];
    subTarget.timer = timer;
    return timer;
}


@end
