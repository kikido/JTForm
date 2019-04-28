//
//  JTFormDescriptor.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTBaseDescriptor.h"
#import "JTSectionDescriptor.h"
#import "JTForm.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JTFormDescriptorDelegate;

@interface JTFormDescriptor : JTBaseDescriptor


/** 是否在表单里为必录项前面添加‘*’符号 */
@property (nonatomic, assign) BOOL addAsteriskToRequiredRowsTitle;

/** 一个集合，key为单元行的tag值，value为单元行。该属性用来判断哪些必录项还没有值以及获取整个表单的数据 */
@property (nonatomic, strong) NSMutableDictionary *allRowsByTag;

@property (nonatomic, assign) id<JTFormDescriptorDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (nonnull instancetype)formDescriptor;

#pragma mark - section

/** 当前表单所有能看到section的集合(不包括隐藏掉的section) */
@property (nonatomic, strong, readonly) NSMutableArray *formSections;

/** 当前表单所有包含着的section集合(包括隐藏掉的，但不包括移除掉的) */
@property (nonatomic, strong, readonly) NSMutableArray *allSections;

/**
 添加段描述
 
 */
- (void)addFormSection:(JTSectionDescriptor *)section;

/**
 添加段描述到指定位置
 
 */
- (void)addFormSection:(JTSectionDescriptor *)section atIndex:(NSInteger)index;


/**
 添加段描述在某个段描述之后

 */
- (void)addFormSection:(JTSectionDescriptor *)section afterSection:(JTSectionDescriptor *)afterSection;


/**
 添加段描述在某个段描述之前

 */
- (void)addFormSection:(JTSectionDescriptor *)section beforeSection:(JTSectionDescriptor *)beforeSection;


/**
 移除某个段描述

 */
- (void)removeFormSection:(JTSectionDescriptor *)section;


/**
 移除某个位置的段描述

 */
- (void)removeFormSectionAtIndex:(NSUInteger)index;


/**
 移除某些位置的段描述

 */
- (void)removeFormSectionsAtIndexes:(NSIndexSet *)indexes;


/**
 根据段描述，判断是该隐藏还是显示单元段

 */
- (void)evaluateFormSectionIsHidden:(JTSectionDescriptor *)section;

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

/** 返回一个‘NSIndexPath’对象，表示行描述代表的单元行在表单中位置 */
- (NSIndexPath *)indexPathForRowDescriptor:(JTRowDescriptor *)rowDescriptor;


#pragma mark - cell

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

- (JTRowDescriptor *)formRowWithTag:(NSString *)tag;

- (JTRowDescriptor *)formRowAtIndex:(NSIndexPath *)indexPath;


@end


/**
 上啦刷新需要实现的方法
 */
@protocol JTFormRefreshDelegate <NSObject>


@end


@protocol JTFormDescriptorDelegate <NSObject>

- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet;

- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet;

- (void)formRowsHaveBeenAddedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)formRowsHaveBeenRemovedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@end

NS_ASSUME_NONNULL_END
