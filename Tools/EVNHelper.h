//
//  EVNHelper.h
//  EVNTouchIDDemo
//
//  Created by developer on 2016/10/18.
//  Copyright © 2016年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVNHelper : NSObject<NSCopying, NSMutableCopying>

@property (assign, nonatomic) BOOL isAppCurrentLoginState;

+ (instancetype)shareHelper;

@end
