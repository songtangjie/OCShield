//
//  NSArray+Shield.h
//  OCShield
//
//  Created by william on 2019/12/12.
//  Copyright © 2019 william. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Shield)

/*
 拦截插入nil引起的崩溃（包含可变数组）
*/
+ (void)shield_interceptArrayCrashCausedByInsertNilObject;

/*
 拦截数组越界引起的崩溃（包含可变数组）
*/
+ (void)shield_interceptArrayCrashCausedByIndexBeyondBounds;

/*
 拦截可变数组特有崩溃
*/
+ (void)shield_interceptMutableArrayCrash;

/*
 拦截数组所有崩溃（包含可变数组）
*/
+ (void)shield_interceptArrayAllCrash;

@end

NS_ASSUME_NONNULL_END
