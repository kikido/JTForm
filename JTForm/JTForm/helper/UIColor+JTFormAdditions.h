//
//  UIColor+JTFormAdditions.h
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JTFormAdditions)


/**
 支持下面几种格式
 
 #ff3131
 ff3131
 #ff313131
 ff313131
 */
+ (UIColor *)jt_colorWithHexString:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END
