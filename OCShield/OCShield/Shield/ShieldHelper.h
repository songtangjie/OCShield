//
//  ShieldHelper.h
//  OCShield
//
//  Created by william on 2019/12/4.
//  Copyright © 2019 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 日志标题线
UIKIT_EXTERN NSString * const ShieldTitleSeparator;
/// 日志分隔线
UIKIT_EXTERN NSString * const ShieldBottomSeparator;

/// 崩溃类型
typedef NS_OPTIONS(NSUInteger, ShieldCrashType)
{
    // 字符串下标或范围越界
    ShieldCrashTypeStringRangeOrIndexOutOfBounds = 1 << 0,
    // 可变数组特有崩溃
    ShieldCrashTypeMutableArrayOwned = 1 << 1,
    // 数组越界
    ShieldCrashTypeArrayIndexBeyondBounds = 1 << 2,
    // 数组插入nil对象
    ShieldCrashTypeArrayAttemptToInsertNilObject = 1 << 3,
    // KVC赋值
    ShieldCrashTypeObjectKVC = 1 << 4,
    // 未找到方法
    ShieldCrashTypeObjectUnrecognizedSelectorSentToInstance = 1 << 5,
    // 定时器未被清除
    ShieldCrashTypeTimerIsNotCleaned = 1 << 6,
    // 字典所有崩溃
    ShieldCrashTypeDictionaryAll = 1 << 7,
    // kvo重复添加
    ShieldCrashTypeObjectKVO = 1 << 8,
    // 富文本所有崩溃
    ShieldCrashTypeAttributedAll = 1 << 9,
    
    // 对象所有崩溃
    ShieldCrashTypeObjectAll = ShieldCrashTypeObjectKVO | ShieldCrashTypeObjectKVC | ShieldCrashTypeObjectUnrecognizedSelectorSentToInstance,
    // 数组所有崩溃
    ShieldCrashTypeArrayAll = ShieldCrashTypeMutableArrayOwned | ShieldCrashTypeArrayIndexBeyondBounds | ShieldCrashTypeArrayAttemptToInsertNilObject,
    // 所有崩溃
    ShieldCrashTypeAll = ShieldCrashTypeStringRangeOrIndexOutOfBounds | ShieldCrashTypeArrayAll | ShieldCrashTypeDictionaryAll | ShieldCrashTypeObjectAll | ShieldCrashTypeTimerIsNotCleaned | ShieldCrashTypeAttributedAll
};

@interface ShieldHelper : NSObject

/*
 交换实例方法
 
 @param cls 类对象
 @param originalSel 原始方法
 @param swizzlingSel 替换方法
 */
+ (void)shield_swizzleInstanceMethodForClass:(Class)cls
                            originalSelector:(SEL)originalSel
                           swizzlingSelector:(SEL)swizzlingSel;

/*
 交换类方法
 
 @param cls 元类对象
 @param originalSel 原始方法
 @param swizzlingSel 替换方法
 */
+ (void)shield_swizzleClassMethodForClass:(Class)cls
                         originalSelector:(SEL)originalSel
                        swizzlingSelector:(SEL)swizzlingSel;

/**
 捕获异常和异常类型
 
 @param exception 异常
 @param type 异常类型
 */
+ (void)shield_catchException:(NSException *)exception
                withCrashType:(ShieldCrashType)type;

@end

NS_ASSUME_NONNULL_END
