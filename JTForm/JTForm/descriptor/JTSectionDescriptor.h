//
//  JTSectionDescriptor.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
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

/**
 节描述，为单元节(section)的数据源。
 */
@interface JTSectionDescriptor : JTBaseDescriptor

/** 在表单中，这一节所有显示出来的单元行集合(不包括隐藏的单元行) */
@property (nonatomic, strong, readonly) NSMutableArray<JTRowDescriptor *> *formRows;

/** 这一节所包含的所有单元行(包括隐藏的单元行) */
@property (nonatomic, strong, readonly) NSMutableArray<JTRowDescriptor *> *allRows;

/** 可编辑类型。目前仅支持可删除 */
@property (nonatomic, assign) JTFormSectionOptions sectionOptions;

#pragma mark - config
/** 头视图。还需要额外设置‘headerHeight’ */
@property (nullable, nonatomic, strong) UIView *headerView;
/** 尾视图。还需要额外设置'footerHeight' */
@property (nullable, nonatomic, strong) UIView *footerView;
/** 这一节的头标题。还需要额外设置‘headerHeight’ */
@property (nonatomic, copy) NSAttributedString *headerAttributedString;
/** 这一节的尾标题。还需要额外设置'footerHeight' */
@property (nonatomic, copy) NSAttributedString *footerAttributedString;
/** 头视图的高度。默认值为25. */
@property (nonatomic, assign) CGFloat headerHeight;
/** 尾视图的高度。默认值为25. */
@property (nonatomic, assign) CGFloat footerHeight;

/** 被包含的表描述，可为空 */
@property (nonatomic, weak) JTFormDescriptor *formDescriptor;



+ (instancetype)formSection;

#pragma mark - row

/** 添加行 */
- (void)addFormRow:(JTRowDescriptor *)row;

/** 在指定行后面添加行。如果指定行不在当前表单内，则添加到当前节的最后一个位置 */
- (void)addFormRow:(JTRowDescriptor *)row afterRow:(JTRowDescriptor *)afterRow;

/** 在指定行前面添加行。如果指定行不在当前表单内，则添加到当前节的最后一个位置 */
- (void)addFormRow:(JTRowDescriptor *)row beforeRow:(JTRowDescriptor *)beforeRow;

/** 移除行 */
- (void)removeFormRow:(JTRowDescriptor *)row;

/** 根据tag移除行 */
- (void)removeFormRowWithTag:(NSString *)tag;

/** 根据index移除行 */
- (void)removeFormRowAtIndex:(NSUInteger)index;

/** fixme。感觉这里不用写 */
- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex;

/** 根据行描述的‘hidden’，来进行相应的隐藏、显示操作 */
- (void)evaluateFormRowIsHidden:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
