//
//  NSAttributedString+JTFormAdditions.h
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (JTFormAdditions)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string
                                              font:(UIFont *)font
                                             color:(nullable UIColor *)color
                                    firstWordColor:(nullable UIColor *)firstWordColor;

+ (NSAttributedString *)rightAttributedStringWithString:(NSString *)string
                                                   font:(UIFont *)font
                                                  color:(nullable UIColor *)color;

@end

NS_ASSUME_NONNULL_END