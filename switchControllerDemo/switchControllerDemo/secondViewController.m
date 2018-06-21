//
//  secondViewController.m
//  switchControllerDemo
//
//  Created by 汪林林 on 2018/6/5.
//  Copyright © 2018年 linlinwang. All rights reserved.
//

#import "secondViewController.h"

@interface secondViewController ()

@end

@implementation secondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
    label.text = @"这是二个viewController ";
    [self.view addSubview:label];
}


@end
