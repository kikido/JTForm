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

typedef NS_OPTIONS(NSUInteger, JTFormSectionOptions) {
    /** 不可编辑 */
    JTFormSectionOptionNone        = 0,
    /** 可删除 */
    JTFormSectionOptionCanDelete   = 1 << 1
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
@property (nonatomic, assign) JTFormSectionOptions sectionOptions;

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
 * 在某单元行后面添加新的单元行
 *
 * @param row 行描述
 * @param afterRow 行描述，对应的单元行需要已经在 form 中了，否则新的单元行将添加到 form 最后面
 */
- (void)addRow:(JTRowDescriptor *)row afterRow:(JTRowDescriptor *)afterRow;

/**
 * 在某单元行前面添加新的单元行
 *
 * @param row 行描述
 * @param beforeRow 行描述，对应的单元行需要已经在 form 中了，否则新的单元行将添加到 form 最前面
 */
- (void)addRow:(JTRowDescriptor *)row beforeRow:(JTRowDescriptor *)beforeRow;

/**
 * 在节上的某个位置上添加单元行
 *
 * @param row 行描述
 * @param index 节中的索引位置
 */
- (void)addRow:(JTRowDescriptor *)row atIndex:(NSUInteger)index;

/**
 * 移除单元行
 *
 * @param row 行描述
 */
- (void)removeRow:(JTRowDescriptor *)row;

/**
 * 移除单元行
 *
 * @param tag 对应单元行的 tag
 */
- (void)removeRowByTag:(NSString *)tag;

/**
 * 在节上根据索引位置移除单元行
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
 * 对单元行执行隐藏或者显示操作
 *
 * @param row 行描述
 */
- (void)evaluateFormRowIsHidden:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
