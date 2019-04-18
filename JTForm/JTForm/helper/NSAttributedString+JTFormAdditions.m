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
                                              font:(UIFont *)font
                                             color:(nullable UIColor *)color
                                    firstWordColor:(nullable UIColor *)firstWordColor
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
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
@end
