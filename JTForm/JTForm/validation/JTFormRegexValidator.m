//
//  JTFormRegexValidator.m
//  JTForm
//
//  Created by dqh on 2019/5/8.
//  Copyright © 2019 dqh. All rights reserved.
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
    BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex] evaluateWithObject:[rowDescriptor.value cellText]];
    if (isValid) {
        return nil;
    }
    return [JTFormValidateObject formValidateObjectWithErrorMsg:self.errorMsg valid:isValid];;
}
@end
