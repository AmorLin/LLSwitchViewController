//
//  switchViewController.m
//  switchControllerDemo
//
//  Created by 汪林林 on 2018/6/4.
//  Copyright © 2018年 linlinwang. All rights reserved.
//

#import "switchViewController.h"
#import "firstTableViewController.h"
#import "secondTableViewController.h"
 
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kBottomMaxHeight 100
#define kHeaderMinHeight -100 - 64
@interface switchViewController ()

@property (nonatomic,strong) UIViewController *firstVC;
@property (nonatomic,strong) UIViewController *secondVC;

@end

@implementation switchViewController


+ (instancetype)inistanceSwitchViewControllerWithFirstViewController:(UIViewController *)firstViewController WithSecondTableViewController:(UIViewController *)secondViewController {
    switchViewController *controller = [[switchViewController alloc]init];
    controller.firstVC = firstViewController;
    controller.secondVC = secondViewController;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self addChildViewController];
  
}


-(void)dealloc{
    
    if ([self.firstVC isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tbc = (UITableViewController *)self.firstVC;
        [tbc.tableView removeObserver:self forKeyPath:@"contentOffset"];
    }else {
        UIScrollView *view = (UIScrollView *)self.firstVC.view.superview;
        [view removeObserver:self forKeyPath:@"contentOffset" ];
    }
    
    if ([self.secondVC isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tbc = (UITableViewController *)self.secondVC;
        [tbc.tableView removeObserver:self forKeyPath:@"contentOffset" ];
    }else {
        UIScrollView *view = (UIScrollView *)self.secondVC.view.superview;
        [view removeObserver:self forKeyPath:@"contentOffset"];
    }
}

/**
 添加自控制器
 */
- (void)addChildViewController {
    
    //第一个控制器
    if (![self.firstVC  isKindOfClass:[UITableViewController class]]) {
         UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.firstVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        scrollview.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        [self.view addSubview:scrollview];
        [scrollview addSubview:self.firstVC.view];
        [scrollview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }else {
        UITableViewController *tbc = (UITableViewController *)self.firstVC;
        tbc.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [tbc.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:tbc.tableView];
    }
   

    if (![self.secondVC  isKindOfClass:[UITableViewController class]]) {
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        self.secondVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        scrollview.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+1);
        [scrollview addSubview:self.secondVC.view];
        [self.view addSubview:scrollview];
        [scrollview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }else {
        UITableViewController *tbc = (UITableViewController *)self.secondVC;
        tbc.tableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        [tbc.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:tbc.tableView];
    }
    [self addChildViewController:self.firstVC];
    [self addChildViewController:self.secondVC];
 
}

 
#pragma mark KVO 监听两个控制器的contentOffset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"contentOffset"] )
    {
        NSValue *oldvalue = change[NSKeyValueChangeOldKey];
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGFloat oldoffset_y = oldvalue.UIOffsetValue.vertical;
        CGFloat newoffset_y = newvalue.UIOffsetValue.vertical;
        
        UITableView *tb = object;
        if (tb.isDragging)  return;
        
        if ([self.firstVC  isKindOfClass:[UITableViewController class]]) {
            UITableViewController *tbc = (UITableViewController *)self.firstVC;
            if (object == tbc.tableView) {
                CGFloat height = tbc.tableView.frame.size.height;
                CGFloat contentYoffset = tbc.tableView.contentOffset.y;
                CGFloat distance = tbc.tableView.contentSize.height - height;
                //            distance = contentYoffset 时达到最底部
                if (contentYoffset - distance >= kBottomMaxHeight)
                {//向上提的状态下
                    [self jumpToPageSecond];
                }
            }
        }else{
            UIScrollView *scrollview = (UIScrollView *)self.firstVC.view.superview;
            if (object == scrollview) {

                CGFloat height = scrollview. frame.size.height;
                CGFloat contentYoffset =  scrollview.contentOffset.y;
                CGFloat distance =  scrollview.contentSize.height - height;
                //   distance = contentYoffset 时达到最底部
                
                if (contentYoffset - distance >= kBottomMaxHeight)
                {//向上提的状态下
                    [self jumpToPageSecond];
                }
            }
        }
        
        if ([self.secondVC  isKindOfClass:[UITableViewController class]]) {
            UITableViewController *tbc = (UITableViewController *)self.secondVC;
            if (object == tbc.tableView) {
                NSLog(@"hello-----:");
                if( newoffset_y < kHeaderMinHeight)
                {// 向下拉的状态
                    [tbc.tableView removeObserver:self forKeyPath:@"contentOffset"];
                    [self jumpToPageFirst];
                }
            }
        }else {
            UIScrollView *scrollview = (UIScrollView *)self.secondVC.view.superview;
            if (object == scrollview) {
                if( newoffset_y < kHeaderMinHeight)
                {// 向下拉的状态
                    [scrollview removeObserver:self forKeyPath:@"contentOffset"];
                    [self jumpToPageFirst];
                 }
            }
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark 设置内容-控制切换动画 跳转到上面index = 1 的控制器
- (void)jumpToPageSecond{
    [UIView animateWithDuration:0.5 animations:^{
        //index == 0  是否跳转到第一页
        if (![self.firstVC isKindOfClass:[UITableViewController class]]) {
            self.firstVC.view.superview.frame =  CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
            if (![self.secondVC isKindOfClass:[UITableViewController class]]) {
                self.secondVC.view.superview.frame =   CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }else{
                
                self.secondVC.view.frame =   CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }
        }else {
            self.firstVC.view.frame =  CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
            if (![self.secondVC isKindOfClass:[UITableViewController class]]) {
                self.secondVC.view.superview.frame =  CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }else{
                
                self.secondVC.view.frame =  CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }
        }
  
        
    } completion:^(BOOL finished) {
    }];
}
//跳转到上面index = 0的控制器
-(void)jumpToPageFirst{
    [UIView animateWithDuration:0.5 animations:^{
        
        //index == 0  是否跳转到第一页
        if (![self.firstVC isKindOfClass:[UITableViewController class]]) {
            self.firstVC.view.superview.frame =   CGRectMake(0, 0, kScreenWidth, kScreenHeight)  ;
            if (![self.secondVC isKindOfClass:[UITableViewController class]]) {
                self.secondVC.view.superview.frame =   CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)  ;
            }else{
                
                self.secondVC.view.frame =   CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight) ;
            }
        }else {
            self.firstVC.view.frame =  CGRectMake(0, 0, kScreenWidth, kScreenHeight)   ;
            if (![self.secondVC isKindOfClass:[UITableViewController class]]) {
                self.secondVC.view.superview.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)  ;
                
            }else{
                
                self.secondVC.view.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)  ;
            }
        }
        
    } completion:^(BOOL finished) {
        if ([self.secondVC isKindOfClass:[UITableViewController class]]) {
            UITableViewController *tbc = (UITableViewController *)self.secondVC;
            [tbc.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"switchControllerKVO"];
        }else {
            UIScrollView *view = (UIScrollView *)self.secondVC.view.superview;
            [view addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"switchControllerKVO"];
        }
        
    }];
}


@end
