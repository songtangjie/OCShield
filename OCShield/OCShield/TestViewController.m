//
//  TestViewController.m
//  OCShield
//
//  Created by william on 2019/12/13.
//  Copyright © 2019 william. All rights reserved.
//

#import "TestViewController.h"
#import "NSTimer+Shield.h"

@interface TestViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TestViewController

- (void)dealloc
{
    NSLog(@"TestViewController 释放了");
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
//    [NSTimer shield_interceptTimerAllCrash];
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.5, 80, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"结束" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)timeRun
{
    NSLog(@"定时器在跑");
}

- (void)clickBtn
{
    NSLog(@"结束定时器");
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
