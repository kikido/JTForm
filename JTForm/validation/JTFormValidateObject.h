//
//  JTFormValidateObject.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTFormValidateObject : NSObject
/** 错误提示 */
@property (nonatomic, copy) NSString *errorMsg;
/** 是否通过验证 */
@property (nonatomic, assign) BOOL valid;

/**
 创建一个 JTFormValidateObjects 实例

 @param errorMsg 自定义的错误提示
 @param valid 是否通过
 @return 返回该实例
 */
- (instancetype)initWithErrorMsg:(nullable NSString *)errorMsg valid:(BOOL)valid;

+ (instancetype)formValidateObjectWithErrorMsg:(nullable NSString *)errorMsg valid:(BOOL)valid;
@end

NS_ASSUME_NONNULL_END
