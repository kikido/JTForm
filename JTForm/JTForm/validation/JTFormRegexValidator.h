//
//  JTFormRegexValidator.h
//  JTForm
//
//  Created by dqh on 2019/5/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTFormValidateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormRegexValidator : NSObject <JTFormValidateProtocol>
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, copy) NSString *regex;

- (instancetype)initWithErrorMsg:(NSString *)errorMsg regex:(NSString *)regex;

+ (JTFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)errorMsg regex:(NSString *)regex;
@end

NS_ASSUME_NONNULL_END
