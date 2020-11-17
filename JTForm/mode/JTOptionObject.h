//
//  JTOptionObject.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 选择项对象。
 *
 * @disucss 分为两部分，一个是展示文本 formDisplayText，另一个是这个选择项代表的 value，这在表单中比较常用
 * 举个例子，这个是三个选择项：【吃饭时间】早饭，午饭，晚饭，那么这几个选择项代表的值可以为 @1，@2，@3。
 * 一般来说，创建实例时传入的 value 如果为空，应该返回 nil，因为选择项实际上使用的还是这个 value。但是有一些公司因为数据库增加了字段的问题，
 * 数据中可能只保存了选择项的 formDisplayText 而缺少 value，但是展示表单时又需要显示 formDisplayText，为了应付这种情况(主要是我司有这种情况...)，
 * 所以即使 value 为空也可以显示这些 选择项。
 */
@interface JTOptionObject : NSObject
/** 选择项的展示文本 */
@property (nonatomic, copy  ) NSString *optionText;
/** 选择项的值 */
@property (nonatomic, strong) id       optionValue;

+ (JTOptionObject *)optionsObjectWithOptionValue:(nullable id)optionValue optionText:(nonnull NSString *)optionText;

+ (NSArray<JTOptionObject *> *)optionObjectsWithOptionValues:(nonnull NSArray *)optionValues optionTexts:(nonnull NSArray<NSString *> *)optionTexts;

- (BOOL)isEqualToOptionObject:(JTOptionObject *)optionObject;

@end

NS_ASSUME_NONNULL_END
