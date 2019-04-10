//
//  JTSectionDescriptor.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTBaseDescriptor.h"
#import "JTRowDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@class JTFormDescriptor;

@interface JTSectionDescriptor : JTBaseDescriptor

/** 在表单中，这一节所有显示出来的单元行集合(不包括隐藏的单元行) */
@property (nonatomic, strong, readonly) NSMutableArray *formRows;

/** 这一节所包含的所有单元行(包括隐藏的单元行) */
@property (nonatomic, strong, readonly) NSMutableArray *allRows;

/** 这一节的头标题 */
@property (nonatomic, copy) NSString *headerTitle;

/** 这一节的尾标题 */
@property (nonatomic, copy) NSString *footerTitle;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, weak) JTFormDescriptor *formDescriptor;

+ (instancetype)formSection;


- (void)addFormRow:(JTRowDescriptor *)row;

- (void)addFormRow:(JTRowDescriptor *)row afterRow:(JTRowDescriptor *)afterRow;

- (void)addFormRow:(JTRowDescriptor *)row beforeRow:(JTRowDescriptor *)beforeRow;

- (void)removeFormRow:(JTRowDescriptor *)row;

- (void)removeFormRowWithTag:(NSString *)tag;

- (void)removeFormRowAtIndex:(NSUInteger)index;

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex;

@end

NS_ASSUME_NONNULL_END
