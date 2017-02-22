### EVNTouchIDDemo

[![Build Status](https://travis-ci.org/zonghongyan/EVNTouchIDDemo.svg?branch=master)](https://travis-ci.org/zonghongyan/EVNTouchIDDemo)
[![License](https://img.shields.io/github/license/zonghongyan/EVNTouchIDDemo.svg?style=flat)](https://github.com/zonghongyan/EVNTouchIDDemo/blob/master/LICENSE)

[iOS指纹识别登录流程及实现](http://www.jianshu.com/p/67fd93408517)


<img src="https://github.com/zonghongyan/EVNTouchIDDemo/blob/master/ResourcesImage/DemoImage/touchid.gif" width="20%" height="20%" alt="Show the figure" >

<img src="https://github.com/zonghongyan/EVNTouchIDDemo/blob/master/ResourcesImage/DemoImage/949086-1a291c4684c42ac3.png" width="45%" height="45%" alt="Show the figure" >
<img src="https://github.com/zonghongyan/EVNTouchIDDemo/blob/master/ResourcesImage/DemoImage/949086-dd8751e1eabc6521.png" width="45%" height="45%" alt="Show the figure" >


```
/**
 * Login fingerprint verification
 */
- (void)loadAuthentication
{
    LAContext *myContext = [[LAContext alloc] init]; 
    // This property is set fingerprint input after the failure of pop-up option
    myContext.localizedFallbackTitle = @"Forgot password";

    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Please hold the Home button to complete the verification";
    // MARK: Whether the equipment support fingerprint identification
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            if(success)
            {
                NSLog(@"Fingerprint authentication success");
            }
            else
            {
                NSLog(@"Fingerprint authentication failed，%@",error.description);

                NSLog(@"%ld", (long)error.code); // error.code
                switch (error.code)
                {
                    case LAErrorAuthenticationFailed: // Authentication was not successful, because user failed to provide valid credentials
                    {
                        NSLog(@"Authorization failure"); // -1 Fingerprint identification error three times in a row
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

```
