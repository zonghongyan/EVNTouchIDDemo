//
//  UserLoginTableViewController.m
//  EVNTouchIDDemo
//
//  Created by developer on 2016/10/17.
//  Copyright © 2016年 仁伯安. All rights reserved.
//

#import "UserLoginTableViewController.h"
#import "UserLoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "EVNHelper.h"

@interface UserLoginTableViewController ()
{

}

@property (weak, nonatomic) IBOutlet UIButton *logoutBtnAction;

@property (weak, nonatomic) IBOutlet UISwitch *isAutoLogin;

@property (weak, nonatomic) IBOutlet UILabel *userInfo;

@property (strong, nonatomic) EVNHelper *helper;

@end

@implementation UserLoginTableViewController
{
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.helper = [EVNHelper shareHelper];
    self.logoutBtnAction.hidden = YES; // 初始化时候就是未登录状态

    LAContext *context = [[LAContext alloc] init]; // 初始化上下文对象
    NSError *error = nil;
    // 判断设备是否支持指纹识别功能
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        // 设备不支持，隐藏掉指纹登录cell，Demo不再实现
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSNumber *isStartAutoLoginState = [[NSUserDefaults standardUserDefaults] objectForKey:@"startAutoLoginState"];
        NSNumber *isLoginState = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginState"];

        if (indexPath.row == 0 && [isLoginState boolValue] && [isStartAutoLoginState boolValue]  && !_helper.isAppCurrentLoginState) // 如果用户登录过且为登录状态，而且开启指纹登录
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证登录" message:@"是否使用指纹登录" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"更换账号" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                [self commonLogin]; // 普通登录

            }];
            UIAlertAction *startUseAction = [UIAlertAction actionWithTitle:@"指纹登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self loadAuthentication];

            }];
            [alertController addAction:cancelAction];
            [alertController addAction:startUseAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (indexPath.row == 0 && !_helper.isAppCurrentLoginState)
        {
            [self commonLogin]; // 普通登录
        }
        else
        {
            // 其他的cell事件
        }
    }
    else
    {
        // 其他的cell事件
    }
}

/**
 * 退出登录按钮
 * @param sender button
 */
- (IBAction)logoutBtnAction:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"loginState"];
    self.userInfo.text = @"用户登录";
    sender.hidden = YES;

    _helper.isAppCurrentLoginState = NO;
}

/**
 * 开启指纹登录Switch
 * @param sender switch控件
 */
- (IBAction)autoLoginAction:(UISwitch *)sender
{
    if ([self loginState])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sender.on] forKey:@"startAutoLoginState"];
    }
    else
    {
        [self commonLogin];
    }
}

/**
 * 判断登录状态
 * @return 是否登录
 */
- (BOOL)loginState
{
    NSNumber *isLoginState = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginState"];

    if ([isLoginState boolValue] && _helper.isAppCurrentLoginState)
    {
        return YES;
    }
    return NO;
}

/**
 * 普通登录
 */
- (void)commonLogin
{
    UserLoginViewController *userLoginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"userLoginViewController"];

    __weak typeof(self) weakSelf = self;
    userLoginViewController.transLoginStateBlock = ^(){
        // 回调状态
        weakSelf.logoutBtnAction.hidden = NO;
        NSNumber *isStartAutoLoginState = [[NSUserDefaults standardUserDefaults] objectForKey:@"startAutoLoginState"];
        weakSelf.isAutoLogin.on = [isStartAutoLoginState boolValue];

        weakSelf.userInfo.text = @"仁伯安";
    };
    [self presentViewController:userLoginViewController animated:YES completion:nil];
}

/**
 * 指纹登录验证
 */
- (void)loadAuthentication
{
    __weak typeof(self) weakSelf = self;

    LAContext *myContext = [[LAContext alloc] init];
    // 这个属性是设置指纹输入失败之后的弹出框的选项
    myContext.localizedFallbackTitle = @"忘记密码";

    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"请按住Home键完成验证";
    // MARK: 判断设备是否支持指纹识别
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            if(success)
            {
                NSLog(@"指纹认证成功");

                weakSelf.helper.isAppCurrentLoginState = YES;

                weakSelf.logoutBtnAction.hidden = NO;
                weakSelf.userInfo.text = @"仁伯安";
            }
            else
            {
                weakSelf.helper.isAppCurrentLoginState = NO;
                NSLog(@"指纹认证失败，%@",error.description);

                NSLog(@"%ld", (long)error.code); // 错误码 error.code
                switch (error.code)
                {
                    case LAErrorAuthenticationFailed: // Authentication was not successful, because user failed to provide valid credentials
                    {
                        NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                    }
                        break;
                    case LAErrorUserCancel: // Authentication was canceled by user (e.g. tapped Cancel button)
                    {
                        NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮

                    }
                        break;
                    case LAErrorUserFallback: // Authentication was canceled, because the user tapped the fallback button (Enter Password)
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                        }];

                    }
                        break;
                    case LAErrorSystemCancel: // Authentication was canceled by system (e.g. another application went to foreground)
                    {
                        NSLog(@"取消授权，如其他应用切入，用户自主"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                    }
                        break;
                    case LAErrorPasscodeNotSet: // Authentication could not start, because passcode is not set on the device.

                    {
                        NSLog(@"设备系统未设置密码"); // -5
                    }
                        break;
                    case LAErrorTouchIDNotAvailable: // Authentication could not start, because Touch ID is not available on the device
                    {
                        NSLog(@"设备未设置Touch ID"); // -6
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                    {
                        NSLog(@"用户未录入指纹"); // -7
                    }
                        break;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
                    case LAErrorTouchIDLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                    {
                        NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    }
                        break;
                    case LAErrorAppCancel: // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
                    {
                        NSLog(@"用户不能控制情况下APP被挂起"); // -9
                    }
                        break;
                    case LAErrorInvalidContext: // LAContext passed to this call has been previously invalidated.
                    {
                        NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                    }
                        break;
#else
#endif
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        NSLog(@"设备不支持指纹");
        NSLog(@"%ld", (long)authError.code);
        weakSelf.helper.isAppCurrentLoginState = NO;
        switch (authError.code)
        {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"Authentication could not start, because Touch ID has no enrolled fingers");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"Authentication could not start, because passcode is not set on the device");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
    }
}


@end
