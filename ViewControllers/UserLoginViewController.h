//
//  UserLoginViewController.h
//  EVNTouchIDDemo
//
//  Created by developer on 2016/10/17.
//  Copyright © 2016年 仁伯安. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^TransLoginStateBlock)();

@interface UserLoginViewController : BaseViewController

@property (copy, nonatomic) TransLoginStateBlock transLoginStateBlock;

@end
