//
//  JTFormRegexValidator.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import "JTFormValidateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormRegexValidator : NSObject <JTFormValidateProtocol>
/** 错误提示 */
@property (nonatomic, copy) NSString *errorMsg;
/** 正则表达式 */
@property (nonatomic, copy) NSString *regex;

- (instancetype)initWithErrorMsg:(NSString *)errorMsg regex:(NSString *)regex;

+ (JTFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)errorMsg regex:(NSString *)regex;
@end

NS_ASSUME_NONNULL_END
