//
//  ShieldProxy.m
//  OCShield
//
//  Created by william on 2019/12/4.
//  Copyright © 2019 william. All rights reserved.
//

#import "ShieldProxy.h"
#import "ShieldHelper.h"

@implementation ShieldProxy

- (void)shield_handleCrashMethod
{
    NSString *exceptionName = @"App crashed due to uncaught exception: unrecognized selector send to instance";
    
    NSString *logExceptionMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n\n%@\n\n",ShieldTitleSeparator, exceptionName, ShieldBottomSeparator];
    
    NSLog(@"%@", logExceptionMessage);
}

@end
