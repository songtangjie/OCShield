//
//  NSDictionary+Shield.m
//  OCShield
//
//  Created by william on 2019/12/13.
//  Copyright © 2019 william. All rights reserved.
//

#import "NSDictionary+Shield.h"
#import "ShieldHelper.h"

@implementation NSDictionary (Shield)

#pragma mark - Public Api
/*
 拦截字符串所有崩溃
*/
+ (void)shield_interceptDictionaryAllCrash
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = NSClassFromString(@"__NSDictionaryM");

        [ShieldHelper shield_swizzleClassMethodForClass:class        originalSelector:@selector(dictionaryWithObjects:forKeys:count:)  swizzlingSelector:@selector(shield_dictionaryWithObjects:forKeys:count:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(setObject:forKey:)  swizzlingSelector:@selector(shield_setObject:forKey:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(shield_setObject:forKeyedSubscript:) swizzlingSelector:@selector(shield_setObject:forKeyedSubscript:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(removeObjectForKey:) swizzlingSelector:@selector(shield_removeObjectForKey:)];
        
    });
}

#pragma mark - Private Api

+ (instancetype)shield_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)count
{
    id instance;
    @try {
        instance = [self shield_dictionaryWithObjects:objects forKeys:keys count:count];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeDictionaryAll];
        
        //去掉nil值重新构造字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[count];
        id  _Nonnull __unsafe_unretained newkeys[count];
        
        for (int i = 0; i < count; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self shield_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
    } @finally {
        return instance;
    }
}

- (void)shield_setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    @try {
        [self shield_setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeDictionaryAll];
    } @finally {
        
    }
}

- (void)shield_setObject:(nullable id)obj forKeyedSubscript:(id <NSCopying>)key
{
    @try {
        [self shield_setObject:obj forKeyedSubscript:key];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeDictionaryAll];
    } @finally {
        
    }
}

- (void)shield_removeObjectForKey:(id)aKey
{
    @try {
        [self shield_removeObjectForKey:aKey];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeDictionaryAll];
    } @finally {
        
    }
}



@end
