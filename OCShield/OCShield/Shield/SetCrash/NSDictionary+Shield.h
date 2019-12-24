//
//  NSDictionary+Shield.h
//  OCShield
//
//  Created by william on 2019/12/13.
//  Copyright © 2019 william. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Shield)

/*
 拦截字符串所有崩溃
*/
+ (void)shield_interceptDictionaryAllCrash;

@end

NS_ASSUME_NONNULL_END
