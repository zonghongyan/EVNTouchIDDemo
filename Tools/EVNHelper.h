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
/************************************************************************
 * 作者: 仁伯安
 * 作者GitHub链接: https://github.com/zonghongyan
 * 作者简书链接：http://www.jianshu.com/users/ac49bc773ff9
 * 著作权归作者所有，转载请联系作者获得授权，并标注“作者”。
 ************************************************************************/
