//
//  NSAttributedString+JTFormAdditions.m
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "NSAttributedString+JTFormAdditions.h"

@implementation NSAttributedString (JTFormAdditions)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string
                                              font:(nullable UIFont *)font
                                             color:(nullable UIColor *)color
                                    firstWordColor:(nullable UIColor *)firstWordColor
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if (!font) {
        font = [UIFont systemFontOfSize:16.];
    }
    if (string) {
        NSDictionary *attributes = @{NSForegroundColorAttributeName: color ? : [UIColor blackColor],
                                                NSFontAttributeName: font};
        attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttributes:attributes range:NSMakeRange(0, string.length)];
        
        if (firstWordColor) {
            NSRange firstWordRange  = NSMakeRange(0, 1);
            [attributedString addAttribute:NSForegroundColorAttributeName value:firstWordColor range:firstWordRange];
        }
    }
    
    return attributedString;
}

+ (NSAttributedString *)rightAttributedStringWithString:(NSString *)string
                                                   font:(nullable UIFont *)font
                                                  color:(nullable UIColor *)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (!font) {
        font = [UIFont systemFontOfSize:16.];
    }
    if (string) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentRight;
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName: color ? : [UIColor blackColor],
                                     NSFontAttributeName: font,
                                     NSParagraphStyleAttributeName:paragraph
                                     };
        attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttributes:attributes range:NSMakeRange(0, string.length)];
    }
    
    return attributedString;
}
@end
