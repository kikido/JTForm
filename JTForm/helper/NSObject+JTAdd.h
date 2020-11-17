//
//  NSObject+JTFormHelper.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void JTLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@interface NSObject (JTAdd)

- (id)valueForForm;

- (NSString *)descriptionForForm;


/**
 * 判断一个对象是否为空
 *
 * @param object oc 对象
 * @return 判断结果，YES 表示为空，NO 表示不为空
 */
BOOL JTIsValueEmpty(id object);

/**
 * 比较两个对象是否相等
 *
 * @discuss 如果对象时 JTOptionObject 类型，当两个对象的 formValue 相等时，
 * 那么我们也认为这两个对象‘相等’
 *
 * @param object 比较对象
 * @return 比较结果
 */
- (BOOL)jt_isEqual:(id)object;
@end

NS_ASSUME_NONNULL_END
