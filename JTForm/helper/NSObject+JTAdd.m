//
//  NSObject+JTFormHelper.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "NSObject+JTAdd.h"
#import "JTOptionObject.h"

void JTLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@implementation NSObject (JTAdd)

- (id)valueForForm
{
    if ([self isKindOfClass:[NSArray class]]) { // for mutable select
        NSMutableArray * result = [NSMutableArray array];
        [(NSArray *)self enumerateObjectsUsingBlock:^(id obj, NSUInteger __unused idx, BOOL __unused *stop) {
            [result addObject:[obj valueForForm]];
        }];
        return result.copy;
    }
    if ([self isKindOfClass:[JTOptionObject class]]) {
        return [(JTOptionObject *)self optionValue];
    }
    return self;
}

BOOL JTIsValueEmpty(id object)
{
    if (!object)                               return true;
    if ([object isKindOfClass:[NSNull class]]) return true;
    
    if ([object isKindOfClass:[NSString class]] && [(NSString *)object length] == 0)
    {
        return true;
    }
    else if ([object isKindOfClass:[NSArray class]] && [(NSArray *)object count] == 0)
    {
        return true;
    }
    else if ([object isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)object allKeys] count] == 0)
    {
        return true;
    }
    return false;
}


- (BOOL)jt_isEqual:(id)object
{
    if (!object)                                return false;
    if (self == object)                         return true;
    if (![object isKindOfClass:[self class]])   return false;
    
    if ([object isKindOfClass:[NSString class]])
    {
        return [(NSString *)object isEqualToString:(NSString *)self];
    }
    else if ([object isKindOfClass:[JTOptionObject class]])
    {
        return [(JTOptionObject *)object isEqualToOptionObject:(JTOptionObject *)self];
    }
    else if ([object isKindOfClass:[NSAttributedString class]])
    {
        return [(NSAttributedString *)object isEqualToAttributedString:(NSAttributedString *)self];
    }
    else if ([object isKindOfClass:[NSData class]])
    {
        return [(NSData *)object isEqualToData:(NSData *)self];
    }
    else if ([object isKindOfClass:[NSDate class]])
    {
        return [(NSDate *)object isEqualToDate:(NSDate *)self];
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)object isEqualToDictionary:(NSDictionary *)self];
    }
    else if ([object isKindOfClass:[NSHashTable class]])
    {
        return [(NSHashTable *)object isEqualToHashTable:(NSHashTable *)self];
    }
    else if ([object isKindOfClass:[NSIndexSet class]])
    {
        return [(NSIndexSet *)object isEqualToIndexSet:(NSIndexSet *)self];
    }
    else if ([object isKindOfClass:[NSNumber class]])
    {
        return [(NSNumber *)object isEqualToNumber:(NSNumber *)self];
    }
    else if ([object isKindOfClass:[NSOrderedSet class]])
    {
        return [(NSOrderedSet *)object isEqualToOrderedSet:(NSOrderedSet *)self];
    }
    else if ([object isKindOfClass:[NSSet class]])
    {
        return [(NSSet *)object isEqualToSet:(NSSet *)self];
    }
    else if ([object isKindOfClass:[NSTimeZone class]])
    {
        return [(NSTimeZone *)object isEqualToTimeZone:(NSTimeZone *)self];
    }
    else if ([object isKindOfClass:[NSValue class]])
    {
        return [(NSValue *)object isEqualToValue:(NSValue *)self];
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        return [(NSArray *)object isEqualToArray:(NSArray *)self];
    }
    else
    {
        return [self isEqual:object];
    }
}

- (NSString *)descriptionForForm
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    else if ([self isKindOfClass:[NSDecimalNumber class]]) {
        return [(NSDecimalNumber *)self descriptionWithLocale:[NSLocale currentLocale]];
    }
    else if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self stringValue];
    }
    else if ([self isKindOfClass:[JTOptionObject class]]) {
        return [(JTOptionObject *)self optionText];
    }
    else if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    else {
        return self.description;
    }
}
@end
