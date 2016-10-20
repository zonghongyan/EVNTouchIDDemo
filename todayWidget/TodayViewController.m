//
//  TodayViewController.m
//  todayWidget
//
//  Created by developer on 2016/10/20.
//  Copyright © 2016年 YUANDONG. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}


- (IBAction)goAppAction:(UIButton *)sender
{
    [self.extensionContext openURL:[NSURL URLWithString:@"todayWidget://"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
}

@end
