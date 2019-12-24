//
//  KvoDelegate.m
//  OCShield
//
//  Created by william on 2019/12/16.
//  Copyright © 2019 william. All rights reserved.
//

#import "KvoDelegate.h"

@implementation KvoInfo

@end

@interface KvoDelegate()

@end

@implementation KvoDelegate

#pragma mark - Lazy
- (NSMutableDictionary *)infoMaps
{
    if (_infoMaps == nil) {
        _infoMaps = [NSMutableDictionary dictionary];
    }
    return _infoMaps;
}

@end
