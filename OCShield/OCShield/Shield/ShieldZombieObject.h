//
//  ShieldZombieObject.h
//  OCShield
//
//  Created by william on 2019/12/17.
//  Copyright © 2019 william. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShieldZombieObject : NSObject

@property (nonatomic, assign, readonly) NSInteger currentClassSize;
// 黑名单集合
@property (nonatomic, strong, readonly) NSMutableSet *blackClassesSet;

+ (instancetype)share;

// 添加黑名单数组
- (void)addBlackArray:(NSArray *)objects;

// 添加实例
- (void)addCurrentZombieClass:(Class)object;

// 移除实例
- (void)removeCurrentZombieClass:(Class)object;

// 获取实例
- (nullable id)objectFromCurrentClassesSet;

@end

NS_ASSUME_NONNULL_END
