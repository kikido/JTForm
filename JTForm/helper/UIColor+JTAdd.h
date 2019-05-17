//
//  UIColor+JTFormAdditions.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor jt_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

@interface UIColor (JTAdd)

/**
 支持下面几种格式:
 #ff3131
 ff3131
 #ff313131
 ff313131
 */
+ (UIColor *)jt_colorWithHexString:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END
