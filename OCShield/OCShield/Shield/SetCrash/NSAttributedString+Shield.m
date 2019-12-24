//
//  NSAttributedString+Shield.m
//  OCShield
//
//  Created by william on 2019/12/23.
//  Copyright © 2019 william. All rights reserved.
//

#import "NSAttributedString+Shield.h"
#import "ShieldHelper.h"

@implementation NSAttributedString (Shield)

#pragma mark - Public Api
/*
 拦截富文本所有崩溃
*/
+ (void)shield_interceptAttributedAllCrash
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = NSClassFromString(@"NSConcreteAttributedString");
        Class classM = NSClassFromString(@"NSConcreteMutableAttributedString");

        // NSConcreteAttributedString
        [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(initWithString:)  swizzlingSelector:@selector(shield_initWithString:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(initWithAttributedString:)  swizzlingSelector:@selector(shield_initWithAttributedString:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(initWithString:attributes:)  swizzlingSelector:@selector(shield_initWithString:attributes:)];
        
        // NSConcreteMutableAttributedString
        [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(initWithString:)  swizzlingSelector:@selector(shield_initWithStringM:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(initWithString:attributes:)  swizzlingSelector:@selector(shield_initWithStringM:attributes:)];
    });
}

#pragma mark - Private Api

// ----------------- NSConcreteAttributedString -------------------
- (instancetype)shield_initWithString:(NSString *)str
{
    id instance;
    @try {
        instance = [self shield_initWithString:str];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeAttributedAll];
    } @finally {
        return instance;
    }
}

- (instancetype)shield_initWithAttributedString:(NSAttributedString *)attrStr
{
    id instance;
    @try {
        instance = [self shield_initWithAttributedString:attrStr];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeAttributedAll];
    } @finally {
        return instance;
    }
}

- (instancetype)shield_initWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs
{
    id instance;
    @try {
        instance = [self shield_initWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeAttributedAll];
        
    } @finally {
        return instance;
    }
}

// ----------------- NSConcreteMutableAttributedString -------------------
- (instancetype)shield_initWithStringM:(NSString *)str
{
    id instance;
    @try {
        instance = [self shield_initWithStringM:str];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeAttributedAll];
    } @finally {
        return instance;
    }
}

- (instancetype)shield_initWithStringM:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs
{
    id instance;
    @try {
        instance = [self shield_initWithStringM:str attributes:attrs];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeAttributedAll];
        
    } @finally {
        return instance;
    }
}

@end
