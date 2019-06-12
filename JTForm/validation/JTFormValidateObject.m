//
//  JTFormValidateObject.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormValidateObject.h"

@implementation JTFormValidateObject

- (instancetype)initWithErrorMsg:(nullable NSString *)errorMsg valid:(BOOL)valid
{
    if (self = [super init]) {
        _errorMsg = errorMsg;
        _valid = valid;
    }
    return self;
}

+ (instancetype)formValidateObjectWithErrorMsg:(nullable NSString *)errorMsg valid:(BOOL)valid
{
    return [[[self class] alloc] initWithErrorMsg:errorMsg valid:valid];
}

@end
