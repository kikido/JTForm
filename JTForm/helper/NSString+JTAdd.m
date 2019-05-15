//
//  NSString+JTAdd.m
//  JTForm
//
//  Created by dqh on 2019/4/24.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "NSString+JTAdd.h"

@implementation NSString (JTAdd)

+ (NSString *)jt_localizedStringForKey:(NSString *)key
{
    if (!key || ![key isKindOfClass:[NSString class]] || key.length == 0) {
        return nil;
    }
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
            language = @"zh-Hans";
        } else {
            language = @"en";
        }
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"JTForm" withExtension:@"bundle"];
        bundle = [NSBundle bundleWithURL:url];
        bundle = [NSBundle bundleWithPath:[bundle pathForResource:language ofType:@"lproj"]];
    }
    NSString *value = [bundle localizedStringForKey:key value:key table:nil];
    
    return value;
}

@end
