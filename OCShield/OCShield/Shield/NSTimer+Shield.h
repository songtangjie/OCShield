//
//  NSTimer+Shield.h
//  OCShield
//
//  Created by william on 2019/12/13.
//  Copyright © 2019 william. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Shield)

/*
 防止定时器无法释放销毁引起崩溃
*/
+ (void)shield_interceptTimerAllCrash;


@end

NS_ASSUME_NONNULL_END
