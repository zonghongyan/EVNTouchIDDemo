//
//  EVNHelper.m
//  EVNTouchIDDemo
//
//  Created by developer on 2016/10/18.
//  Copyright © 2016年 YUANDONG. All rights reserved.
//

#import "EVNHelper.h"

static id _instance;

@implementation EVNHelper

/**
 *  只要系统中引用了该类，程序运行，就会主动调用load（不用手动调用，而且只会加载1次）
 */
+ (void)load
{
    _instance = [[EVNHelper alloc] init]; //[[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}


@end
