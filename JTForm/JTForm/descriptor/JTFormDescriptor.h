//
//  JTFormDescriptor.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTBaseDescriptor.h"
#import "JTSectionDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JTFormDescriptorDelegate;

@interface JTFormDescriptor : JTBaseDescriptor

/** 当前表单所有能看到section的集合(不包括隐藏掉的section) */
@property (nonatomic, strong, readonly) NSMutableArray *formSections;

/** 当前表单所有包含着的section集合(包括隐藏掉的，但不包括移除掉的) */
@property (nonatomic, strong, readonly) NSMutableArray *allSections;

/** 是否在那些必填的单元行的标题前显示一个不同颜色的‘*’符号 */
@property (nonatomic, assign) BOOL addAsteriskToRequiredRowsTitle;

/** 一个集合，key为单元行的tag值，value为单元行。该属性用来判断哪些必录项还没有值以及获取整个表单的数据 */
@property (nonatomic, strong) NSMutableDictionary *allRowsByTag;

@property (nonatomic, assign) id<JTFormDescriptorDelegate> delegate;

+ (nonnull instancetype)formDescriptor;

#pragma mark - section


/**
 添加段描述
 
 */
- (void)addFormSection:(JTSectionDescriptor *)section;

/**
 添加段描述在指定位置
 
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


- (void)evaluateFormSectionIsHidden:(JTSectionDescriptor *)section;

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


@protocol JTFormDescriptorDelegate <NSObject>

- (void)formSectionHasBeenRemoved:(JTSectionDescriptor *)formSection atIndex:(NSUInteger)index;

- (void)formSectionHasBeenAdded:(JTSectionDescriptor *)formSection atIndex:(NSUInteger)index;

- (void)formRowHasBeenAdded:(JTRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath;

- (void)formRowHasBeenRemoved:(JTRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
