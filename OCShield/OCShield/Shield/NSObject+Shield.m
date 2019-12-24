//
//  NSObject+Shield.m
//  OCShield
//
//  Created by william on 2019/12/4.
//  Copyright © 2019 william. All rights reserved.
//

#import "NSObject+Shield.h"
#import "ShieldHelper.h"
#import "ShieldProxy.h"
#import <objc/runtime.h>
#import "KvoDelegate.h"
#import "ShieldZombieObject.h"
#import "ShieldZombieSub.h"

#define ZoombieMaxCache 1024 * 1024 * 5

static const char *KvoDelegateKey;

@interface NSObject()
// kvo代理
@property (strong, nonatomic) KvoDelegate *kvoDelegate;

@end

@implementation NSObject (Shield)

#pragma mark - Public Api

/*
 拦截对象所有崩溃
*/
+ (void)shield_interceptObjectAllCrash
{
    [self shield_interceptObjectCrashCausedByKVC];
    [self shield_crashCausedByUnrecognizedSelectorSentToInstance];
    [self shield_interceptObjectCrashCausedByKVO];
}

/*
 拦截由于未找到方法引起的崩溃
*/
+ (void)shield_crashCausedByUnrecognizedSelectorSentToInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //通过对forwardingTargetForSelector拦截，可以减少内存开销
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(methodSignatureForSelector:) swizzlingSelector:@selector(shield_methodSignatureForSelector:)];
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(forwardInvocation:) swizzlingSelector:@selector(shield_forwardInvocation:)];
        
        [ShieldHelper shield_swizzleClassMethodForClass:object_getClass(self) originalSelector:@selector(methodSignatureForSelector:) swizzlingSelector:@selector(shield_methodSignatureForSelector:)];
        [ShieldHelper shield_swizzleClassMethodForClass:object_getClass(self) originalSelector:@selector(forwardInvocation:) swizzlingSelector:@selector(shield_forwardInvocation:)];
    });
}

/*
 拦截由于KVC引起的崩溃
*/
+ (void)shield_interceptObjectCrashCausedByKVC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(setValue:forKey:) swizzlingSelector:@selector(shield_setValue:forKey:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(setValue:forKeyPath:) swizzlingSelector:@selector(shield_setValue:forKeyPath:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(setValue:forUndefinedKey:) swizzlingSelector:@selector(shield_setValue:forUndefinedKey:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(setValuesForKeysWithDictionary:) swizzlingSelector:@selector(shield_setValuesForKeysWithDictionary:)];
    });
}

/*
 拦截由于KVO引起的崩溃
*/
- (void)shield_interceptObjectCrashCausedByKVO
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.kvoDelegate = [[KvoDelegate alloc] init];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(addObserver:forKeyPath:options:context:) swizzlingSelector:@selector(shield_addObserver:forKeyPath:options:context:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(removeObserver:forKeyPath:context:) swizzlingSelector:@selector(shield_removeObserver:forKeyPath:context:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(removeObserver:forKeyPath:) swizzlingSelector:@selector(shield_removeObserver:forKeyPath:)];
        
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(observeValueForKeyPath:ofObject:change:context:) swizzlingSelector:@selector(shield_observeValueForKeyPath:ofObject:change:context:)];
        
         [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:NSSelectorFromString(@"dealloc") swizzlingSelector:NSSelectorFromString(@"shield_kvo_dealloc")];
    });
}

/*
 拦截由于野指针引起的崩溃
*/
+ (void)shield_interceptObjectCrashCausedByZombie
{
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ShieldHelper shield_swizzleInstanceMethodForClass:[self class] originalSelector:NSSelectorFromString(@"dealloc") swizzlingSelector:NSSelectorFromString(@"shield_zombie_dealloc")];
        
        [[ShieldZombieObject share] addBlackArray:@[[self class]]];
    });
}

#pragma mark - Private Api

// ************************* Instance *********************************

- (NSMethodSignature *)shield_methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [self shield_methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [ShieldProxy instanceMethodSignatureForSelector:@selector(shield_handleCrashMethod)];
    }
    return signature;
}

- (void)shield_forwardInvocation:(NSInvocation *)anInvocation
{
    @try {
        [self shield_forwardInvocation:anInvocation];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeObjectUnrecognizedSelectorSentToInstance];
    } @finally {
        
    }
}


// ************************* KVC *********************************
- (void)shield_setValue:(nullable id)value forKey:(NSString *)key
{
    @try {
        [self shield_setValue:value forKey:key];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeObjectKVC];
    } @finally {
        
    }
}

- (void)shield_setValue:(nullable id)value forKeyPath:(NSString *)keyPath
{
    @try {
        [self shield_setValue:value forKeyPath:keyPath];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeObjectKVC];
    } @finally {
        
    }
}

- (void)shield_setValue:(nullable id)value forUndefinedKey:(NSString *)key
{
    @try {
        [self shield_setValue:value forUndefinedKey:key];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeObjectKVC];
    } @finally {
        
    }
}

- (void)shield_setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues
{
    @try {
        [self shield_setValuesForKeysWithDictionary:keyedValues];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeObjectKVC];
    } @finally {
        
    }
}

// ************************* Class *********************************

+ (NSMethodSignature *)shield_methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [self shield_methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [ShieldProxy instanceMethodSignatureForSelector:@selector(shield_handleCrashMethod)];
    }
    return signature;
}

+ (void)shield_forwardInvocation:(NSInvocation *)anInvocation
{
    @try {
        [NSObject shield_forwardInvocation:anInvocation];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeObjectUnrecognizedSelectorSentToInstance];
    } @finally {
        
    }
}


// ************************* KVO *********************************
- (void)shield_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([self.kvoDelegate.infoMaps objectForKey:keyPath]) {
        NSMutableArray<KvoInfo *> *infoArray = [self.kvoDelegate.infoMaps objectForKey:keyPath];
        for (KvoInfo *info in infoArray) {
            if (info.observer == observer) {
                NSLog(@"%@重复添加监听%@",observer,keyPath);
            } else {
                KvoInfo *info = [[KvoInfo alloc] init];
                info.observer = observer;
                
                [infoArray addObject:info];
                [self.kvoDelegate.infoMaps setObject:infoArray forKey:keyPath];
            }
        }
        
    } else {
        KvoInfo *info = [[KvoInfo alloc] init];
        info.observer = observer;
        
        NSMutableArray<KvoInfo *> *infoArray = [NSMutableArray arrayWithObject:info];
        [self.kvoDelegate.infoMaps setObject:infoArray forKey:keyPath];
        [self shield_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)shield_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    if ([self.kvoDelegate.infoMaps objectForKey:keyPath]) {
        NSMutableArray<KvoInfo *> *infoArray = [self.kvoDelegate.infoMaps objectForKey:keyPath];
        for (KvoInfo *info in infoArray) {
            if (!info.observer || info.observer == observer) {
                [infoArray removeObject:info];
            }
        }
        
        [self.kvoDelegate.infoMaps setObject:infoArray forKey:keyPath];
        
        if (infoArray.count == 0) {
            [self.kvoDelegate.infoMaps removeObjectForKey:keyPath];
            [self shield_removeObserver:observer forKeyPath:keyPath context:context];
        }
        
    } else {
        NSLog(@"%@移除不存在的监听%@",observer,keyPath);
    }
}

- (void)shield_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if ([self.kvoDelegate.infoMaps objectForKey:keyPath]) {
        NSMutableArray<KvoInfo *> *infoArray = [self.kvoDelegate.infoMaps objectForKey:keyPath];
        for (KvoInfo *info in infoArray) {
            if (!info.observer || info.observer == observer) {
                [infoArray removeObject:info];
            }
        }
        
        [self.kvoDelegate.infoMaps setObject:infoArray forKey:keyPath];
        
        if (infoArray.count == 0) {
            [self.kvoDelegate.infoMaps removeObjectForKey:keyPath];
            [self shield_removeObserver:observer forKeyPath:keyPath];
        }
        
    } else {
        NSLog(@"%@移除不存在的监听%@",observer,keyPath);
    }
}

- (void)shield_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([self.kvoDelegate.infoMaps objectForKey:keyPath]) {
       NSMutableArray<KvoInfo *> *infoArray = [self.kvoDelegate.infoMaps objectForKey:keyPath];
       for (KvoInfo *info in infoArray) {
           if (info.observer) {
               // 调用系统原生方法
               [self shield_observeValueForKeyPath:keyPath ofObject:info.observer change:change context:context];
           } else {
               [infoArray removeObject:info];
           }
       }
       [self.kvoDelegate.infoMaps setObject:infoArray forKey:keyPath];
   }
}

- (void)shield_kvo_dealloc
{
    if (self.kvoDelegate.infoMaps) {
        [self.kvoDelegate.infoMaps removeAllObjects];
    }
    self.kvoDelegate = nil;
}

// ************************* Zombie *********************************

- (void)shield_zombie_dealloc
{
    Class currentClass = self.class;
    
    // 不在黑名单里调系统原生释放方法
    if (![[ShieldZombieObject share].blackClassesSet containsObject:currentClass]) {
        [self shield_zombie_dealloc];
    }

    if ([ShieldZombieObject share].currentClassSize > ZoombieMaxCache) {//设置最大缓存上限5M
        id object = [[ShieldZombieObject share] objectFromCurrentClassesSet];
        [[ShieldZombieObject share] removeCurrentZombieClass:object_getClass(object)];
        object ? free(object) : nil;
    }
    
    objc_destructInstance(self);
    
    object_setClass(self, [ShieldZombieSub class]);
    [[ShieldZombieObject share] addCurrentZombieClass:currentClass];
}

#pragma mark - Public Api

- (KvoDelegate *)kvoDelegate
{
    return objc_getAssociatedObject(self, &KvoDelegateKey);
}

- (void)setKvoDelegate:(KvoDelegate *)kvoDelegate
{
    objc_setAssociatedObject(self, &KvoDelegateKey, kvoDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
