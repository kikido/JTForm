//
//  JTFormRegexValidator.m
//  JTForm
//
//  Created by dqh on 2019/5/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormRegexValidator.h"
#import "JYFormValidatorProtocol.h"

@implementation JTFormRegexValidator
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *regex;

- (instancetype)initWithErrorMsg:(NSString *)errorMsg regex:(NSString *)regex;

+ (JTFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regexString:(NSString *)regex;
@end
