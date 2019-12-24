//
//  NSAttributedString+Shield.h
//  OCShield
//
//  Created by william on 2019/12/23.
//  Copyright © 2019 william. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Shield)

/*
 拦截富文本所有崩溃
*/
+ (void)shield_interceptAttributedAllCrash;

@end

NS_ASSUME_NONNULL_END
