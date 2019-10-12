//
//  JTFormValidateProtocol.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JTFormValidateObject;
@class JTRowDescriptor;

@protocol JTFormValidateProtocol <NSObject>

/**
 验证单元行的 value 是否符合规则

 @param rowDescriptor 单元行
 @return 验证结果。验证失败会返回一个 JTFormValidateObject 实例，在 JTForm 中验证成功均返回 nil
 */
- (JTFormValidateObject *)isValid:(JTRowDescriptor *)rowDescriptor;
@end

NS_ASSUME_NONNULL_END
