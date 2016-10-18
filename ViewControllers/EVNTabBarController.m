//
//  EVNTabBarController.m
//  EVNTouchIDDemo
//
//  Created by developer on 2016/10/17.
//  Copyright © 2016年 仁伯安. All rights reserved.
//

#import "EVNTabBarController.h"

@interface EVNTabBarController ()

@end

@implementation EVNTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

     [self initCustomBar];

    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]]; // tabbar背景
    [[UITabBar appearance] setTintColor:[UIColor redColor]]; // 标题字
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]]; // 颜色
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
- (void)initCustomBar
{
    UIImage *selecthomeImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HostViewSelect" ofType:@"png"]];
    UIImage *unSelecthomeImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HostViewUnSelect" ofType:@"png"]];
    UINavigationController *hostNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"hostNavVC"];
    hostNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[self scaleImage:unSelecthomeImg] selectedImage:[self scaleImage:selecthomeImg]];
    hostNavVC.tabBarItem.tag = 0;



    UIImage *selectOtherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CategoryViewSelect" ofType:@"png"]];
    UIImage *unSelectOtherImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CategoryViewUnSelect" ofType:@"png"]];
    UINavigationController *otherNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"otherNav"];
    otherNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"其他" image:[self scaleImage:unSelectOtherImg] selectedImage:[self scaleImage:selectOtherImg]];
    otherNavVC.tabBarItem.tag = 1;

    UIImage *imViewSelectImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MeViewSelect" ofType:@"png"]];
    UIImage *imViewUnSelectImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MeViewUnSelect" ofType:@"png"]];
    UINavigationController *mineSBNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mineNavVC"];
    mineSBNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[self scaleImage:imViewUnSelectImg] selectedImage:[self scaleImage:imViewSelectImg]];
    mineSBNavVC.tabBarItem.tag = 2;

    self.viewControllers = @[hostNavVC, otherNavVC, mineSBNavVC];
}

- (UIImage *)scaleImage:(UIImage *)image
{
    return [UIImage imageWithCGImage:image.CGImage scale:1.5 orientation:image.imageOrientation];
}


@end
