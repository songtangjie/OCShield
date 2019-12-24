//
//  ShieldZombieSub.m
//  OCShield
//
//  Created by william on 2019/12/23.
//  Copyright © 2019 william. All rights reserved.
//

#import "ShieldZombieSub.h"
#import <objc/runtime.h>

@interface ZombieSelectorHandle : NSObject

@property (nonatomic,readwrite, assign) id fromObject;

@end

@implementation ZombieSelectorHandle

void unrecognizedSelectorZombie(ZombieSelectorHandle *self, SEL _cmd){
    
}

@end


@interface ShieldZombieSub()

@end

@implementation ShieldZombieSub

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSMethodSignature *sign = [self methodSignatureForSelector:aSelector];
    if (!sign) {
        id stub = [ZombieSelectorHandle new];
        [stub setFromObject:self];
        class_addMethod([stub class], aSelector, (IMP)unrecognizedSelectorZombie, "v@:");
        return stub;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
