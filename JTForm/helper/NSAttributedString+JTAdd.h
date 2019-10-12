//
//  NSAttributedString+JTFormAdditions.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (JTAdd)

+ (NSAttributedString *)jt_attributedStringWithString:(NSString *)string
                                                 font:(nullable UIFont *)font
                                                color:(nullable UIColor *)color
                                       firstWordColor:(nullable UIColor *)firstWordColor;

+ (NSAttributedString *)jt_attributedStringWithString:(NSString *)string
                                                 font:(nullable UIFont *)font
                                                color:(nullable UIColor *)color;

+ (NSAttributedString *)jt_rightAttributedStringWithString:(NSString *)string
                                                      font:(nullable UIFont *)font
                                                     color:(nullable UIColor *)color;
@end

NS_ASSUME_NONNULL_END
