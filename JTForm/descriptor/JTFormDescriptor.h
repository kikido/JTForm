//
//  JTFormDescriptor.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseDescriptor.h"
#import "JTFormDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class JTRowDescriptor;
@class JTSectionDescriptor;
@class JTForm;

/**
 * 表描述，即表单的数据源。
 */
@interface JTFormDescriptor : JTBaseDescriptor

/** 是否在必录单元行的标题前面添加红色的星号*。默认值为 NO */
@property (nonatomic, assign) BOOL addAsteriskToRequiredRowsTitle;

/** tag -> 单元行，的集合 */
@property (nonatomic, strong, readonly) NSMutableDictionary *allRowsByTag;

/** 代理 */
@property (nonatomic, weak) id<JTFormDescriptorDelegate> form;

/**
 * 没有value的选择项是否显示文本。default is NO，即没有 value 时不显示 text
 *
 * @note：该属性仅适用于 `选择项` 样式的单元行
 * 某些公司的数据库可能比较老，一些选择项可能只有文本但没有 value，
 * 刚好你又碰上某些产品经理要你显示选择的文本(即使没有value)。所以使用这个属性来控制，默认是没有value时不显示文本
 */
@property (nonatomic, assign) BOOL noValueShowText;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

+ (nonnull instancetype)formDescriptor;

//------------------------------
/// @name collection view
///-----------------------------

/** 有几列 */
@property (nonatomic, assign) NSUInteger numberOfColumn;

/**
 * 单个 item 的固定size
 *
 * @discuss 当 JTFromType (@see @c JTFromType) 为 JTFromTypeCollectionFixed 时生效，此时 item 的 size 大小为该固定值，
 * 不再根据布局自动计算
 */
@property (nonatomic, assign) CGSize itmeSize;

/**
 * 每一行之间的间隔
 *
 * @discuss 当 JTFormScrollDirection (@see @c JTFormScrollDirection) 为 JTFormScrollDirectionHorizontal 时，
 * ‘行’指的是 column 而不是 row，而当方向为 JTFormScrollDirectionVertical 时，‘行’指的是 row 而不是 column
 */
@property (nonatomic, assign) CGFloat lineSpace;

/**
 * 同一行 item 之间的间隔
 *
 * @discuss 当 JTFormScrollDirection (@see @c JTFormScrollDirection) 为 JTFormScrollDirectionHorizontal 时，
 * 同一‘行’指的是同一 column 而不是同一 row，而当方向为 JTFormScrollDirectionVertical 时，‘行’指的是 row 而不是 column
 */
@property (nonatomic, assign) CGFloat interItemSpace;

/** 每一个 section 的内边距 */
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

/** 滑动方向 */
@property (nonatomic, assign) JTFormScrollDirection scrollDirection;


//------------------------------
/// @name section
///-----------------------------

/**
 * 表单中所有显示的节
 *
 * @note 不包括隐藏的或者移除掉的节
 */
@property (nonatomic, strong, readonly) NSMutableArray<JTSectionDescriptor *> *formSections;

/**
 * 表单中所有存在的节
 *
 * @note 包括隐藏的节
 */
@property (nonatomic, strong, readonly) NSMutableArray<JTSectionDescriptor *> *allSections;

/**
 * 在表单上添加节
 *
 * @param section 节描述
 */
- (void)addSection:(JTSectionDescriptor *)section;

/**
 * 在表单上指定位置添加节
 *
 * @param section 节描述
 * @param index 在表单中的索引位置
 */
- (void)addSection:(JTSectionDescriptor *)section atIndex:(NSUInteger)index;

/**
 * 在指定节后面添加新的节
 *
 * @param section 新添加节的节描述
 * @param afterSection 表单中已存在的节
 */
- (void)addSection:(JTSectionDescriptor *)section afterSection:(JTSectionDescriptor *)afterSection;

/**
 * 在指定节前面添加新的节
 *
 * @param section 新添加节的节描述
 * @param beforeSection 表单中已存在的节
 */
- (void)addSection:(JTSectionDescriptor *)section beforeSection:(JTSectionDescriptor *)beforeSection;

/**
 * 在表单中移除节
 *
 * @param section 需要移除节的节描述
 */
- (void)removeSection:(JTSectionDescriptor *)section;

/**
 * 移除表单中某个位置的节
 *
 * @param index 需要移除节的索引位置
 */
- (void)removeSectionAtIndex:(NSUInteger)index;

/**
 * 移除某些索引位置上的节
 *
 * @param indexes 节的索引集合
 */
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;

/**
 * 对节执行隐藏或者显示操作
 *
 * @param section 节描述
 */
- (void)evaluateFormSectionIsHidden:(JTSectionDescriptor *)section;

/**
 * 查找给定索引位置的节描述
 *
 * @param index 给定的索引位置
 * @return 节描述。如果不在表单范围内则返回 nil
 */
- (JTSectionDescriptor *)sectionAtIndex:(NSUInteger)index;


//------------------------------
/// @name row
///-----------------------------

/**
 * 查找给定单元行在表单中的索引位置
 *
 * @param rowDescriptor 行描述
 * @return 单元行的索引位置，如果不在表单范围内则返回 nil
 */
- (nullable NSIndexPath *)indexPathForRowDescriptor:(JTRowDescriptor *)rowDescriptor;

/**
 * 根据 tag 查找对应的单元行
 *
 * @param tag 单元行的 tag
 * @return 行描述
 */
- (nullable JTRowDescriptor *)formRowWithTag:(id<NSCopying>)tag;

/**
 * 根据指定的索引查找相应的单元行
 *
 * @param indexPath 在表单中的索引位置
 * @return 索引指示的单元行。如果索引超出范围则返回 nil
 */
- (nullable JTRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath;


//------------------------------
/// @name tag collection
///-----------------------------

/**
 * 将单元行存储在 tag 集合中
 *
 * @note 映射关系为 tag -> 单元行，所以 tag 不能重复
 *
 * @param row 行描述
 */
- (void)addRowToTagCollection:(JTRowDescriptor *)row;

/**
 * 将单元行从 tag 集合中移除
 *
 * @param row 行描述
 */
- (void)removeRowFromTagCollection:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
