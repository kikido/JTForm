//
//  JTFormValidateObject.m
//  JTForm
//
//  Created by dqh on 2019/5/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormValidateObject.h"

@implementation JTFormValidateObject

- (instancetype)initWithErrorMsg:(NSString *)errorMsg valid:(BOOL)valid
{
    if (self = [super init]) {
        _errorMsg = errorMsg;
        _valid = valid;
    }
    return self;
}

+ (instancetype)formValidateObjectWithErrorMsg:(NSString *)errorMsg valid:(BOOL)valid
{
    return [[[self class] alloc] initWithErrorMsg:errorMsg valid:valid];
}

@end
