//
//  JTFormDescriptor.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@class JTRowDescriptor;
@class JTSectionDescriptor;
@class JTForm;


/**
 表描述，即表单的数据源。
 */
@interface JTFormDescriptor : JTBaseDescriptor

/** 是否在表单里为必录项前面添加‘*’符号。默认值为‘NO’ */
@property (nonatomic, assign) BOOL addAsteriskToRequiredRowsTitle;

/** 一个集合：key为单元行的tag值，value为单元行。 */
@property (nonatomic, strong) NSMutableDictionary *allRowsByTag;

/** 代理，执行一些行、节的增减操作 */
@property (nonatomic, weak) id<JTFormDescriptorDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (nonnull instancetype)formDescriptor;

#pragma mark - section

/** 当前表单所有能看到section的集合(不包括隐藏掉的section) */
@property (nonatomic, strong, readonly) NSMutableArray<JTSectionDescriptor *> *formSections;

/** 当前表单所有包含着的section集合(包括隐藏掉的，但不包括移除掉的) */
@property (nonatomic, strong, readonly) NSMutableArray<JTSectionDescriptor *> *allSections;

/** 添加节 */
- (void)addFormSection:(JTSectionDescriptor *)section;

/** 在指定位置添加节 */
- (void)addFormSection:(JTSectionDescriptor *)section atIndex:(NSInteger)index;

/** 在指定节后面添加节 */
- (void)addFormSection:(JTSectionDescriptor *)section afterSection:(JTSectionDescriptor *)afterSection;

/** 在指定节前面添加节 */
- (void)addFormSection:(JTSectionDescriptor *)section beforeSection:(JTSectionDescriptor *)beforeSection;

/** 移除节 */
- (void)removeFormSection:(JTSectionDescriptor *)section;

/** 移除某个位置的节 */
- (void)removeFormSectionAtIndex:(NSUInteger)index;

/**  移除某些位置的节 */
- (void)removeFormSectionsAtIndexes:(NSIndexSet *)indexes;

/** 根据节描述的‘hidden’，来进行相应的隐藏、显示操作 */
- (void)evaluateFormSectionIsHidden:(JTSectionDescriptor *)section;

#pragma mark - section

- (JTSectionDescriptor *)formSectionAtIndex:(NSUInteger)index;

#pragma mark - row

/**
 找出在当前行描述后面的行描述

 @return 排在当前行描述后面的行描述。该行描述代表的单元行是显示在表单中的
 */
- (JTRowDescriptor *)nextRowDescriptorForRow:(JTRowDescriptor *)currentRow;

/**
 找出在当前行描述前面的行描述
 
 @return 排在当前行描述前面的行描述。该行描述代表的单元行是显示在表单中的
 */
- (JTRowDescriptor *)previousRowDescriptorForRow:(JTRowDescriptor *)currentRow;

/** 返回一个‘NSIndexPath’对象，表示单元行在表单中位置 */
- (NSIndexPath *)indexPathForRowDescriptor:(JTRowDescriptor *)rowDescriptor;

/** 根据tag值找到对应的行描述 */
- (JTRowDescriptor *)formRowWithTag:(NSString *)tag;

/** 根据‘NSIndexPath’值找到对应的行描述 */
- (JTRowDescriptor *)formRowAtIndex:(NSIndexPath *)indexPath;


#pragma mark - tag collection

/**
 将单元行添加到属性`allRowsByTag`中
 
 @param row 单元行tag值不能为空
 */
- (void)addRowToTagCollection:(JTRowDescriptor *)row;

/**
 从属性`allRowsByTag中移除单元行`

 @param row 单元行tag值不能为空
 */
- (void)removeRowFromTagCollection:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
