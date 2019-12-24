//
//  NSString+Shield.m
//  OCShield
//
//  Created by william on 2019/12/13.
//  Copyright © 2019 william. All rights reserved.
//

#import "NSString+Shield.h"
#import "ShieldHelper.h"

@implementation NSString (Shield)

#pragma mark - Public Api
/*
 拦截字符串所有崩溃
*/
+ (void)shield_interceptStringAllCrash
{
    static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           
           Class class = NSClassFromString(@"__NSCFConstantString");
           Class classM = NSClassFromString(@"__NSCFString");

           [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(characterAtIndex:)  swizzlingSelector:@selector(shield_characterAtIndex:)];
           
           [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(substringFromIndex:)  swizzlingSelector:@selector(shield_substringFromIndex:)];
           
           [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(substringToIndex:) swizzlingSelector:@selector(shield_substringToIndex:)];
           
           [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(substringWithRange:) swizzlingSelector:@selector(shield_substringWithRange:)];
           
           [ShieldHelper shield_swizzleInstanceMethodForClass:class     originalSelector:@selector(stringByReplacingCharactersInRange:withString:)  swizzlingSelector:@selector(shield_stringByReplacingCharactersInRange:withString:)];
           
          [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(stringByReplacingOccurrencesOfString:withString:) swizzlingSelector:@selector(shield_stringByReplacingOccurrencesOfString:withString:)];
           
           [ShieldHelper shield_swizzleInstanceMethodForClass:class        originalSelector:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) swizzlingSelector:@selector(shield_stringByReplacingOccurrencesOfString:withString:options:range:)];
           
           
           [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(replaceCharactersInRange:withString:) swizzlingSelector:@selector(shield_replaceCharactersInRange:withString:)];
           
           [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(insertString:atIndex:) swizzlingSelector:@selector(shield_insertString:atIndex:)];
           
           [ShieldHelper shield_swizzleInstanceMethodForClass:classM        originalSelector:@selector(deleteCharactersInRange:) swizzlingSelector:@selector(shield_deleteCharactersInRange:)];
           
       });
}

#pragma mark - Private Api

- (unichar)shield_characterAtIndex:(NSUInteger)index
{
    unichar c;
    @try {
        c = [self shield_characterAtIndex:index];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
    } @finally {
        
    }
}

- (NSString *)shield_substringFromIndex:(NSUInteger)from
{
    NSString *str;
    @try {
        str = [self shield_substringFromIndex:from];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
        str = @"";
    } @finally {
        return str;
    }
}

- (NSString *)shield_substringToIndex:(NSUInteger)to
{
    NSString *str;
    @try {
        str = [self shield_substringToIndex:to];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
        str = @"";
    } @finally {
        return str;
    }
}

- (NSString *)shield_substringWithRange:(NSRange)range
{
    NSString *str;
    @try {
        str = [self shield_substringWithRange:range];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
        str = @"";
    } @finally {
        return str;
    }
}

- (NSString *)shield_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
{
    NSString *str;
    @try {
        str = [self shield_stringByReplacingCharactersInRange:range withString:replacement];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
        str = @"";
    } @finally {
        return str;
    }
}

- (NSString *)shield_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
{
    NSString *str;
    @try {
        str = [self shield_stringByReplacingOccurrencesOfString:target withString:replacement];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
        str = @"";
    } @finally {
        return str;
    }
}

- (NSString *)shield_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    NSString *str;
    @try {
        str = [self shield_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
        str = @"";
    } @finally {
        return str;
    }
}

- (void)shield_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    @try {
        [self shield_replaceCharactersInRange: range withString: aString];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
    } @finally {
    }
}

- (void)shield_insertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    @try {
        [self shield_insertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
    } @finally {
    }
}

- (void)shield_deleteCharactersInRange:(NSRange)range
{
    @try {
        [self shield_deleteCharactersInRange:range];
    } @catch (NSException *exception) {
        [ShieldHelper shield_catchException:exception withCrashType:ShieldCrashTypeStringRangeOrIndexOutOfBounds];
    } @finally {
    }
}

@end
