//
//  UIColor+JTFormAdditions.m
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "UIColor+JTFormAdditions.h"

@implementation UIColor (JTFormAdditions)

+ (UIColor *)jt_colorWithHexString:(NSString *)hexStr
{
    CGFloat r, g, b, a;
    if (jt_hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

static BOOL jt_hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a)
{
    str = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = jt_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = jt_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = jt_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = jt_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = jt_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = jt_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = jt_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = jt_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

static inline NSUInteger jt_hexStrToInt(NSString *str)
{
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}
@end
