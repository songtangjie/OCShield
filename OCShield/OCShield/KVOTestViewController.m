//
//  KVOTestViewController.m
//  OCShield
//
//  Created by william on 2019/12/16.
//  Copyright © 2019 william. All rights reserved.
//

#import "KVOTestViewController.h"
#import "NSObject+Shield.h"

@interface KVOTestViewController ()

@property (nonatomic, strong) NSString *changeStr;

@end

@implementation KVOTestViewController

- (void)dealloc
{
    NSLog(@"KVOTestViewController 释放");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSLog(@"%@",self.changeStr);
     });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    [KVOTestViewController shield_interceptObjectCrashCausedByZombie];
    
//    self.changeStr = @"1";
//
//    [self shield_interceptObjectCrashCausedByKVO];
//
//    [self addObserver:self forKeyPath:@"changeStr" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//
//    self.changeStr = @"3";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"changeStr"]) {
        NSLog(@"old--%@",change[@"old"]);
        NSLog(@"new--%@",change[@"new"]);
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self removeObserver:self forKeyPath:@"changeStr"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
