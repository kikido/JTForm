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

@interface JTFormDescriptor : JTBaseDescriptor

/** 当前表单所有能看到section的集合(不包括隐藏掉的section) */
@property (nonatomic, strong) NSMutableArray *formSections;

/** 当前表单所有包含着的section集合(包括隐藏掉的，但不包括移除掉的) */
@property (nonatomic, strong) NSMutableArray *allSections;

/** 是否在那些必填的单元行的标题前显示一个不同颜色的‘*’符号 */
@property (nonatomic, assign) BOOL addAsteriskToRequiredRowsTitle;

/** 一个集合，key为单元行的tag值，value为单元行 */
@property (nonatomic, strong) NSMutableDictionary *allRowsByTag;

+ (nonnull instancetype)formDescriptor;

- (void)addRowToTagCollection:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
