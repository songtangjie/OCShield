//
//  NSObject+Shield.h
//  OCShield
//
//  Created by william on 2019/12/4.
//  Copyright © 2019 william. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Shield)

/*
 拦截对象所有崩溃
*/
+ (void)shield_interceptObjectAllCrash;

/*
 拦截由于未找到方法引起的崩溃
 */
+ (void)shield_crashCausedByUnrecognizedSelectorSentToInstance;

/*
 拦截由于KVC引起的崩溃
*/
+ (void)shield_interceptObjectCrashCausedByKVC;

/*
 拦截由于KVO引起的崩溃
*/
- (void)shield_interceptObjectCrashCausedByKVO;

/*
 拦截由于野指针引起的崩溃【延迟释放，超过阈值还是会crash，一般用于检测】
*/
+ (void)shield_interceptObjectCrashCausedByZombie;


@end

NS_ASSUME_NONNULL_END
