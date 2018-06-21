//
//  ViewController.m
//  switchControllerDemo
//
//  Created by 汪林林 on 2018/6/4.
//  Copyright © 2018年 linlinwang. All rights reserved.
//

#import "ViewController.h"
#import "switchViewController.h"
#import "firstTableViewController.h"
#import "secondTableViewController.h"
#import "firstViewController.h"
#import "secondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    but.backgroundColor = [UIColor redColor];
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
}

- (void)click {
    
    firstTableViewController *one = [[firstTableViewController alloc]init];
    secondTableViewController *two = [[secondTableViewController alloc] init];
    firstViewController *oneVC = [[firstViewController alloc]init];
    secondViewController *twoVC = [[secondViewController alloc]init];
//    switchViewController *vc = [switchViewController inistanceSwitchViewControllerWithFirstTableViewController:one WithSecondTableViewController:two];
    
    switchViewController *vc = [switchViewController inistanceSwitchViewControllerWithFirstViewController:oneVC WithSecondTableViewController:twoVC];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
