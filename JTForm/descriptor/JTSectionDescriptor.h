//
//  JTSectionDescriptor.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@class JTFormDescriptor;
@class JTRowDescriptor;

extern CGFloat const JTFormDefaultSectionHeaderHeight;
extern CGFloat const JTFormDefaultSectionFooterHeight;

typedef NS_OPTIONS(NSUInteger, JTSectionOptions) {
    /** 不可编辑 */
    JTSectionOptionNone        = 0,
    /** 可删除 */
    JTSectionOptionCanDelete   = 1 << 1
};

/** 节描述，为单元节(section)的数据源 */
@interface JTSectionDescriptor : JTBaseDescriptor

/**
 * 表单中这一节显示的所有单元行
 *
 * @note 不包括隐藏的或者移除掉的单元行
 */
@property (nonatomic, strong, readonly) NSMutableArray<JTRowDescriptor *> *formRows;

/**
 * 表单中这一节包含的所有单元行
 *
 * @note 包括隐藏的单元行
 */
@property (nonatomic, strong, readonly) NSMutableArray<JTRowDescriptor *> *allRows;

/**
 * 编辑类型
 *
 * @discuss 类似于 UITableView 中左滑显示的删除或者添加操作，
 * 目前仅支持删除操作。设置后，可左滑进行删除单元行操作
 */
@property (nonatomic, assign) JTSectionOptions sectionOptions;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

+ (instancetype)formSection;



//------------------------------
/// @name UI
///-----------------------------

/**
 * 节的头视图
 *
 * @note 还需要设置属性 headerHeight，给定一个高度。
 * 该属性与headerAttributedString冲突，优先级 headerView > headerAttributedString
 */
@property (nullable, nonatomic, strong) UIView *headerView;

/**
 * 节的尾视图
 *
 * @note 还需要设置属性 footerHeight，给定一个高度。
 * 该属性与footerAttributedString冲突，优先级 footerView > footerAttributedString
 */
@property (nullable, nonatomic, strong) UIView *footerView;

/**
 * 这一节的 header title
 *
 * @note 还需要设置属性 footerHeight，给定一个高度。
 * 该属性与headerAttributedString冲突，优先级 headerView > headerAttributedString
 */
@property (nonatomic, copy) NSAttributedString *headerAttributedString;

/**
 * 这一节的 footer title
 *
 * @note 还需要设置属性 footerHeight，给定一个高度。
 * 该属性与footerAttributedString冲突，优先级 footerView > footerAttributedString
 */
@property (nonatomic, copy) NSAttributedString *footerAttributedString;

/**
 * header view 的高度
 *
 * default 是25.0f
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 * footer view 的高度
 *
 * default 是25.0f
 */
@property (nonatomic, assign) CGFloat footerHeight;

/**
 * 被包含的表描述
 *
 * @note 可能为空。比如当这个节被移除表单或者尚未添加到表单的时候
 */
@property (nullable, nonatomic, weak) JTFormDescriptor *formDescriptor;



//------------------------------
/// @name row
///-----------------------------

/**
 * 添加单元行
 *
 * @param row 行描述
 */
- (void)addRow:(JTRowDescriptor *)row;

/**
 * 添加一些单元行
 *
 * @param rows 行描述数组
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows;

/**
 * 在节上的某个位置上添加单元行
 *
 * @note 当单元行在表中隐藏时，我们认为该单元行的 index 并没有改变。
 * 举个例子，rowA rowB 的 index 分别为 1 和 2，当 rowA 在表单中被隐藏时，rowB 的 index 仍旧为 2
 *
 * @param rows 行描述数组
 * @param index 节中的索引位置
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows atIndex:(NSUInteger)index;

/**
 * 在某单元行前面添加新的单元行
 *
 * @param rows 行描述数组
 * @param beforeRow 行描述，对应的行描述需要已经被添加到节描述中，否则直接返回
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows beforeRow:(JTRowDescriptor *)beforeRow;

/**
 * 在某单元行后面添加新的单元行
 *
 * @param rows 行描述数组
 * @param afterRow 行描述，对应的行描述需要已经被添加到节描述中，否则直接返回
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows afterRow:(JTRowDescriptor *)afterRow;

/**
 * 移除单元行
 *
 * @param row 行描述
 */
- (void)removeRow:(JTRowDescriptor *)row;

/**
 * 移除一些单元行
 *
 * @param rows 行描述数组
 */
- (void)removeRows:(NSArray<JTRowDescriptor *> *)rows;

/**
 * 根据 tag 移除单元行
 *
 * @param tag 对应单元行的 tag
 */
- (void)removeRowByTag:(id<NSCopying>)tag;

/**
 * 根据在节上根据索引位置移除单元行
 *
 * @param index 在节中的索引位置
 */
- (void)removeRowAtIndex:(NSUInteger)index;

/**
 * 替换该节中所有的单元行
 *
 * @param rows 用来替换旧单元行的行描述。如果为 nil，则仅仅是将旧单元行删除
 */
- (void)replaceAllRows:(nullable NSArray<JTRowDescriptor *> *)rows;

/**
 * 行在节中的索引位置
 *
 * @discuss 如果单元行不在表单中，返回 NSNotFound
 *
 * @param row 行
 */
- (NSUInteger)indexOfRow:(JTRowDescriptor *)row;

/**
* 节中的指定索引位置的行
*
* @discuss 如果单元行不在节中，返回 nil
*
* @param index 索引位置
*/
- (JTRowDescriptor *)rowAtIndex:(NSUInteger)index;

/**
 * 对单元行执行隐藏或者显示操作
 *
 * @param row 行描述
 */
- (void)evaluateFormRowIsHidden:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
