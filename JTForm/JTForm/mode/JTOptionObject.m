//
//  JTOptionObject.m
//  JTForm
//
//  Created by dqh on 2019/4/22.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTOptionObject.h"
#import "NSObject+JTFormHelper.h"

@implementation JTOptionObject

- (instancetype)initWithValue:(id)value displayText:(NSString *)displayText
{
    if (self = [super init]) {
        _formValue = value;
        _formDisplayText = displayText;
    }
    return self;
}

+(JTOptionObject *)formOptionsObjectWithValue:(nonnull id)value displayText:(nonnull NSString *)displayText
{
    return [[[self class] alloc] initWithValue:value displayText:displayText];
}

+ (NSArray<JTOptionObject *> *)formOptionsObjectsWithValues:(nonnull NSArray *)values displayTexts:(nonnull NSArray *)displayTexts
{
    NSAssert((values && values.count == displayTexts.count), @"values's count must equal to displayTexts's count");
    NSMutableArray *temp = @[].mutableCopy;
    for (NSInteger i = 0; i < values.count; i++) {
        JTOptionObject *object = [[[self class] alloc] initWithValue:values[i] displayText:displayTexts[i]];
        [temp addObject:object];
    }
    return temp.copy;
}

- (BOOL)isEqualToOptionObject:(JTOptionObject *)optionObject
{
    if (!optionObject) {
        return NO;
    }
    if (![optionObject isKindOfClass:[JTOptionObject class]]) {
        return NO;
    }
    if (self == optionObject) {
        return YES;
    }
    if ([[self cellValue] jt_isEqual:[optionObject cellValue]]) {
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p>: text:%@ value:%@", NSStringFromClass([self class]), &self, self.formDisplayText, self.formValue];
}

@end
