//
//  JTFormRegexValidator.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormRegexValidator.h"
#import "JTRowDescriptor.h"

@implementation JTFormRegexValidator

- (instancetype)initWithErrorMsg:(NSString *)errorMsg regex:(NSString *)regex
{
    if (self = [super init]) {
        _errorMsg = errorMsg;
        _regex = regex;
    }
    return self;
}

+ (JTFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)errorMsg regex:(NSString *)regex
{
    return [[[self class] alloc] initWithErrorMsg:errorMsg regex:regex];
}

- (JTFormValidateObject *)isValid:(JTRowDescriptor *)rowDescriptor
{
    BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex] evaluateWithObject:[rowDescriptor.value descriptionForForm]];
    return [JTFormValidateObject formValidateObjectWithErrorMsg:self.errorMsg valid:isValid];
}
@end
