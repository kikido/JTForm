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

- (instancetype)initWithOptionValue:(id)optionValue optionText:(NSString *)optionText
{
    if (self = [super init]) {
        _optionValue = optionValue;
        _optionText  = optionText;
    }
    return self;
}

+ (JTOptionObject *)optionsObjectWithOptionValue:(nullable id)optionValue optionText:(nonnull NSString *)optionText
{
    return [[[self class] alloc] initWithOptionValue:optionValue optionText:optionText];
}

+ (NSArray<JTOptionObject *> *)optionObjectsWithOptionValues:(nonnull NSArray *)optionValues optionTexts:(nonnull NSArray *)optionTexts
{
    NSAssert((optionValues && optionValues.count == optionTexts.count), @"values's count must equal to displayTexts's count");
    NSMutableArray *temp = @[].mutableCopy;
    for (NSInteger i = 0; i < optionValues.count; i++) {
        JTOptionObject *object = [[[self class] alloc] initWithOptionValue:optionValues[i] optionText:optionTexts[i]];
        [temp addObject:object];
    }
    return temp.copy;
}

- (BOOL)isEqualToOptionObject:(JTOptionObject *)optionObject
{
    if (![optionObject isKindOfClass:[JTOptionObject class]]) return false;
    if (self == optionObject)                                 return true;
    
    return [[self valueForForm] jt_isEqual:[optionObject valueForForm]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> text:%@ value:%@", NSStringFromClass([self class]), self, self.optionText, self.optionValue];
}

@end
