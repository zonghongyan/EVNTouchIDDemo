//
//  BaseViewController.m
//  EVNTouchIDDemo
//
//  Created by developer on 2016/10/17.
//  Copyright © 2016年 仁伯安. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:self action:@selector(back:)];
    [back setTitle:@""];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = back;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) back:(UIBarButtonItem *) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
