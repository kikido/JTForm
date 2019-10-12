//
//  NSAttributedString+JTFormAdditions.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "NSAttributedString+JTAdd.h"

@implementation NSAttributedString (JTAdd)

+ (NSAttributedString *)jt_attributedStringWithString:(NSString *)string
                                                 font:(nullable UIFont *)font
                                                color:(nullable UIColor *)color
                                       firstWordColor:(nullable UIColor *)firstWordColor
{
    if (!string) return nil;
    if (!font)  font = [UIFont systemFontOfSize:16.];
    if (!color) color = [UIColor blackColor];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: color,
                                 NSFontAttributeName: font                                 
                                 };
    attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:attributes range:NSMakeRange(0, string.length)];
    
    if (firstWordColor) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:firstWordColor range:NSMakeRange(0, 1)];
    }
    return attributedString;
}

+ (NSAttributedString *)jt_attributedStringWithString:(NSString *)string
                                                 font:(nullable UIFont *)font
                                                color:(nullable UIColor *)color
{
    return [NSAttributedString jt_attributedStringWithString:string font:font color:color firstWordColor:nil];
}


+ (NSAttributedString *)jt_rightAttributedStringWithString:(NSString *)string
                                                      font:(nullable UIFont *)font
                                                     color:(nullable UIColor *)color
{
    if (!string) return nil;
    if (!font)  font = [UIFont systemFontOfSize:16.];
    if (!color) color = [UIColor blackColor];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentRight;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: color,
                                 NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:attributes range:NSMakeRange(0, string.length)];
    
    return attributedString;
}
@end
