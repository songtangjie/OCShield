//
//  ViewController.m
//  OCShield
//
//  Created by william on 2019/12/4.
//  Copyright © 2019 william. All rights reserved.
//

#import "ViewController.h"
#import "TestTool.h"
#import "NSObject+Shield.h"
#import "NSArray+Shield.h"
#import "TestViewController.h"
#import "NSString+Shield.h"
#import "NSDictionary+Shield.h"
#import "KVOTestViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [NSDictionary shield_interceptDictionaryAllCrash];
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"a" forKey:@"a"];
//    NSDictionary *dict = @{@"a":@"b",@"b":@"c"};
    
//    NSString *str;
//    [dict setValue:@"a" forKey:str];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    TestViewController *vc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
