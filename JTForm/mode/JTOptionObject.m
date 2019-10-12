//
//  JTOptionObject.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTOptionObject.h"
#import "NSObject+JTAdd.h"

@implementation JTOptionObject

- (instancetype)initWithValue:(id)value displayText:(NSString *)displayText
{
    if (self = [super init]) {
        _formValue = value;
        _formDisplayText = displayText;
    }
    return self;
}

+(JTOptionObject *)formOptionsObjectWithValue:(nullable id)value displayText:(nonnull NSString *)displayText
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
    if (![optionObject isKindOfClass:[JTOptionObject class]]) return false;
    if (self == optionObject)                                 return true;
    
    return [[self cellValue] jt_isEqual:[optionObject cellValue]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> text:%@ value:%@", NSStringFromClass([self class]), self, self.formDisplayText, self.formValue];
}

@end
