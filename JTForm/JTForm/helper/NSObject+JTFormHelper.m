//
//  NSObject+JTFormHelper.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "NSObject+JTFormHelper.h"
#import "JTOptionObject.h"

@implementation NSObject (JTFormHelper)

- (id)valueData
{
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSDate class]]){
        return self;
    }
    if ([self isKindOfClass:[NSArray class]]) {
        NSMutableArray * result = [NSMutableArray array];
        [(NSArray *)self enumerateObjectsUsingBlock:^(id obj, NSUInteger __unused idx, BOOL __unused *stop) {
            [result addObject:[obj valueData]];
        }];
        return result.copy;
    }
    if ([self isKindOfClass:[JTOptionObject class]]) {
        return [(JTOptionObject *)self formValue];
    }
    return self;
}

- (BOOL)jt_isNotEmpty
{
    return YES;
}

- (BOOL)jt_isEqual:(id)object
{
    if (!object) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }
    if ([object isKindOfClass:[NSString class]]) {
        return [(NSString *)object isEqualToString:(NSString *)self];
    }
    else if ([object isKindOfClass:[NSAttributedString class]]) {
        return [(NSAttributedString *)object isEqualToAttributedString:(NSAttributedString *)self];
    }
    else if ([object isKindOfClass:[NSData class]]) {
        return [(NSData *)object isEqualToData:(NSData *)self];
    }
    else if ([object isKindOfClass:[NSDate class]]) {
        return [(NSDate *)object isEqualToDate:(NSDate *)self];
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)object isEqualToDictionary:(NSDictionary *)self];
    }
    else if ([object isKindOfClass:[NSHashTable class]]) {
        return [(NSHashTable *)object isEqualToHashTable:(NSHashTable *)self];
    }
    else if ([object isKindOfClass:[NSIndexSet class]]) {
        return [(NSIndexSet *)object isEqualToIndexSet:(NSIndexSet *)self];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)object isEqualToNumber:(NSNumber *)self];
    }
    else if ([object isKindOfClass:[NSOrderedSet class]]) {
        return [(NSOrderedSet *)object isEqualToOrderedSet:(NSOrderedSet *)self];
    }
    else if ([object isKindOfClass:[NSSet class]]) {
        return [(NSSet *)object isEqualToSet:(NSSet *)self];
    }
    else if ([object isKindOfClass:[NSTimeZone class]]) {
        return [(NSTimeZone *)object isEqualToTimeZone:(NSTimeZone *)self];
    }
    else if ([object isKindOfClass:[NSValue class]]) {
        return [(NSValue *)object isEqualToValue:(NSValue *)self];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        return [(NSArray *)object isEqualToArray:(NSArray *)self];
    } else {
        return [self isEqual:object];
    }
}

- (NSString *)displayText
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSNumber class]]) {
        return [self description];
    }
    else if ([self isKindOfClass:[JTOptionObject class]]) {
        return [(JTOptionObject *)self formDisplayText];
    } else {
        // fixme
        return self.description;
    }
}

@end
