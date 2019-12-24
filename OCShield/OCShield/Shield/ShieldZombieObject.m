//
//  ShieldZombieObject.m
//  OCShield
//
//  Created by william on 2019/12/17.
//  Copyright © 2019 william. All rights reserved.
//

#import "ShieldZombieObject.h"
#import <objc/runtime.h>

@interface ShieldZombieObject()

// 对象集合
@property (nonatomic, strong) NSMutableSet *classesSet;
// 黑名单集合
@property (nonatomic, strong) NSMutableSet *blackClassesSet;
// 当前已添加对象总size
@property (nonatomic, assign) NSInteger currentClassSize;

@end

@implementation ShieldZombieObject

+ (instancetype)share
{
    static ShieldZombieObject *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[ShieldZombieObject alloc] init];
    });
    return obj;
}

/// 添加黑名单数组
- (void)addBlackArray:(NSArray *)objects
{
    if (objects) {
        [self.blackClassesSet addObjectsFromArray:objects];
    }
}

- (void)addCurrentZombieClass:(Class)object
{
    if (object) {
        self.currentClassSize = self.currentClassSize + class_getInstanceSize(object);
        [self.classesSet addObject:object];
    }
}

- (void)removeCurrentZombieClass:(Class)object
{
    if (object) {
        self.currentClassSize = self.currentClassSize - class_getInstanceSize(object);
        [self.classesSet removeObject:object];
    }
}

- (nullable id)objectFromCurrentClassesSet
{
    NSEnumerator *objectEnum = [self.classesSet objectEnumerator];
    for (id object in objectEnum) {
        return object;
    }
    return nil;
}

- (NSMutableSet *)classesSet
{
    if (_classesSet == nil) {
        _classesSet = [NSMutableSet set];
    }
    return _classesSet;
}

- (NSMutableSet *)blackClassesSet
{
    if (_blackClassesSet == nil) {
        _blackClassesSet = [NSMutableSet set];
    }
    return _blackClassesSet;
}

@end
