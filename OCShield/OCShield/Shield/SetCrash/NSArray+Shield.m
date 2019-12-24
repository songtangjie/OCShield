//
//  NSArray+Shield.m
//  OCShield
//
//  Created by william on 2019/12/12.
//  Copyright © 2019 william. All rights reserved.
//

#import "NSArray+Shield.h"
#import "ShieldHelper.h"

@implementation NSArray (Shield)

#pragma mark - Public Api
/*
 拦截数组由于插入nil引起的崩溃（包含可变数组）
*/
+ (void)shield_interceptArrayCrashCausedByInsertNilObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ShieldHelper shield_swizzleClassMethodForClass:[self class]        originalSelector:@selector(arrayWithObjects:count:) swizzlingSelector:@selector(shield_arrayWithObjects:count:)];
        
//        [ShieldHelper shield_swizzleClassMethodForClass:[self class]        originalSelector:@selector(arrayWithObjects:) swizzlingSelector:@selector(shield_arrayWithObjects:)];
        
        [ShieldHelper shield_swizzleClassMethodForClass:[self class]        originalSelector:@selector(arrayWithObject:) swizzlingSelector:@selector(shield_arrayWithObject:)];
    });
}

/*
 拦截数组越界引起的崩溃（包含可变数组）
*/
+ (void)shield_interceptArrayCrashCausedByIndexBeyondBounds
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class classI = NSClassFromString(@"__NSArrayI");
        Class class0 = NSClassFromString(@"__NSArray0");
        Class classM = NSClassFromString(@"__NSArrayM");
        Class classS = NSClassFromString(@"__NSSingleObjectArrayI");

        // __NSArrayI
        [ShieldHelper shield_swizzleInstanceMethodForClass:classI        originalSelector:@selector(objectAtIndex:)  swizzlingSelector:@selector(shield_objectAtIndexI:)];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
            [ShieldHelper shield_swizzleInstanceMethodForClass:classI        originalSelector:@selector(objectAtIndexedSubscript:)  swizzlingSelector:@selector(shield_objectAtIndexedSubscriptI:)];
        }
        [ShieldHelper shield_swizzleInstanceMethodForClass:classI originalSelector:@selector(getObjects:range:) swizzlingSelector:@selector(shield_getObjectsI:range:)];
        
        // __NSArray0
        [ShieldHelper shield_swizzleInstanceMethodForClass:class0        originalSelector:@selector(objectAtIndex:) swizzlingSelector:@selector(shield_objectAtIndex0:)];
        
        // __NSArrayM
        [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(objectAtIndex:) swizzlingSelector:@selector(shield_objectAtIndexM:)];
        [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(objectAtIndexedSubscript:)  swizzlingSelector:@selector(shield_objectAtIndexedSubscriptM:)];
        [ShieldHelper shield_swizzleInstanceMethodForClass:classM originalSelector:@selector(getObjects:range:) swizzlingSelector:@selector(shield_getObjectsM:range:)];
        
        // __NSSingleObjectArrayI
        [ShieldHelper shield_swizzleInstanceMethodForClass:classS        originalSelector:@selector(objectAtIndex:) swizzlingSelector:@selector(shield_objectAtIndexS:)];
        [ShieldHelper shield_swizzleInstanceMethodForClass:classI originalSelector:@selector(getObjects:range:) swizzlingSelector:@selector(shield_getObjectsS:range:)];
        
    });
}

/*
 拦截可变数组特有崩溃
*/
+ (void)shield_interceptMutableArrayCrash
{
    static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class classM = NSClassFromString(@"__NSArrayM");
            
            // setObject:atIndexedSubscript:
            [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(setObject:atIndexedSubscript:)  swizzlingSelector:@selector(shield_setObject:atIndexedSubscript:)];
            
            // removeObjectAtIndex:
            [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(removeObjectAtIndex:)  swizzlingSelector:@selector(shiled_removeObjectAtIndex:)];
            
            // insertObject:atIndex:
            [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(insertObject:atIndex:)  swizzlingSelector:@selector(shield_insertObject:atIndex:)];
        });
}

/*
 拦截数组所有崩溃（包含可变数组）
*/
+ (void)shield_interceptArrayAllCrash
{
    [self shield_interceptArrayCrashCausedByInsertNilObject];
    [self shield_interceptArrayCrashCausedByIndexBeyondBounds];
    [self shield_interceptMutableArrayCrash];
}

#pragma mark - Private Api

// ********************* InsertNilObject **************************

+ (instancetype)shield_arrayWithObjects:(const id _Nonnull __unsafe_unretained *)objects count:(NSUInteger)count
{
    id instance = nil;
    @try {
        instance = [self shield_arrayWithObjects:objects count:count];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayAttemptToInsertNilObject];
        
        // 去掉nil值重新构造数组
        NSInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[count];
        for (int i = 0; i < count; i++) {
            if (objects[i] != nil) {
                newObjects[index] = objects[i];
                index++;
            }
        }
        
        instance = [self shield_arrayWithObjects:newObjects count:index];
    } @finally {
        return instance;
    }
}

+ (instancetype)shield_arrayWithObjects:(const id _Nonnull __unsafe_unretained *)objects
{
    id instance = nil;
    @try {
        instance = [self shield_arrayWithObjects:objects];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayAttemptToInsertNilObject];
        
        // 去掉nil值重新构造数组
//        NSArray *data = (NSArray *)objects;
//        NSMutableArray *newObjects = [NSMutableArray array];
//        for (int i = 0; i < data.count; i++) {
//            if (data[i] != nil) {
//                [newObjects addObject:data[i]];
//            }
//        }
//        
//        instance = [self shield_arrayWithObjects:newObjects];
    } @finally {
        return instance;
    }
}

+ (instancetype)shield_arrayWithObject:(const id _Nonnull __unsafe_unretained *)object
{
    id instance = nil;
    @try {
        instance = [self shield_arrayWithObject:object];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayAttemptToInsertNilObject];
        
        instance = @[];
    } @finally {
        return instance;
    }
}

// ********************* BeyondBounds **************************

- (id)shield_objectAtIndexI:(NSUInteger)index
{
    id object;
    @try {
        object = [self shield_objectAtIndexI:index];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (id)shield_objectAtIndexedSubscriptI:(NSUInteger)idx
{
    id object;
    @try {
        object = [self shield_objectAtIndexedSubscriptI:idx];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (void)shield_getObjectsI:(id  _Nonnull __unsafe_unretained [])objects range:(NSRange)range
{
    @try {
        [self shield_getObjectsI:objects range:range];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayAttemptToInsertNilObject];
    } @finally {

    }
}

- (id)shield_objectAtIndex0:(NSUInteger)index
{
    id object;
    @try {
        object = [self shield_objectAtIndex0:index];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (id)shield_objectAtIndexM:(NSUInteger)index
{
    id object;
    @try {
        object = [self shield_objectAtIndexM:index];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (id)shield_objectAtIndexedSubscriptM:(NSUInteger)idx
{
    id object;
    @try {
        object = [self shield_objectAtIndexedSubscriptM:idx];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (void)shield_getObjectsM:(id  _Nonnull __unsafe_unretained [])objects range:(NSRange)range
{
    @try {
        [self shield_getObjectsM:objects range:range];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayAttemptToInsertNilObject];
    } @finally {

    }
}

- (id)shield_objectAtIndexS:(NSUInteger)index
{
    id object;
    @try {
        object = [self shield_objectAtIndexS:index];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (void)shield_getObjectsS:(id  _Nonnull __unsafe_unretained [])objects range:(NSRange)range
{
    @try {
        [self shield_getObjectsS:objects range:range];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayAttemptToInsertNilObject];
    } @finally {

    }
}

// ********************* NSMutableArray **************************
- (void)shield_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    @try {
        [self shield_setObject:obj atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayAttemptToInsertNilObject];
    } @finally {
        
    }
}

- (void)shiled_removeObjectAtIndex:(NSUInteger)idx
{
    @try {
        [self shiled_removeObjectAtIndex:idx];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayIndexBeyondBounds];
    } @finally {

    }
}

- (void)shield_insertObject:(id)obj atIndex:(NSUInteger)idx
{
    @try {
        [self shield_insertObject:obj atIndex:idx];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeArrayAttemptToInsertNilObject];
    } @finally {

    }
}


@end
