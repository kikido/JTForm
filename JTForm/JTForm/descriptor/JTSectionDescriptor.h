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
    JTFormSectionOptionNone        = 0,
    JTFormSectionOptionCanDelete   = 1 << 1
};

@interface JTSectionDescriptor : JTBaseDescriptor

/** 在表单中，这一节所有显示出来的单元行集合(不包括隐藏的单元行) */
@property (nonatomic, strong, readonly) NSMutableArray *formRows;

/** 这一节所包含的所有单元行(包括隐藏的单元行) */
@property (nonatomic, strong, readonly) NSMutableArray *allRows;

@property (nonatomic, assign) JTFormSectionOptions sectionOptions;

#pragma mark -
@property (nullable, nonatomic, strong) UIView *headerView;

@property (nullable, nonatomic, strong) UIView *footerView;
/** 这一节的头标题 */
@property (nonatomic, copy) NSAttributedString *headerAttributedString;
/** 这一节的尾标题 */
@property (nonatomic, copy) NSAttributedString *footerAttributedString;
/** 头视图的高度。默认值为25. */
@property (nonatomic, assign) CGFloat headerHeight;
/** 尾视图的高度。默认值为25. */
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, weak) JTFormDescriptor *formDescriptor;

+ (instancetype)formSection;

#pragma mark - row

- (void)addFormRow:(JTRowDescriptor *)row;

- (void)addFormRow:(JTRowDescriptor *)row afterRow:(JTRowDescriptor *)afterRow;

- (void)addFormRow:(JTRowDescriptor *)row beforeRow:(JTRowDescriptor *)beforeRow;

- (void)removeFormRow:(JTRowDescriptor *)row;

- (void)removeFormRowWithTag:(NSString *)tag;

- (void)removeFormRowAtIndex:(NSUInteger)index;

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex;

- (void)evaluateFormRowIsHidden:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
