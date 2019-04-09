//
//  JTRowDescriptor.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTBaseDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@class JTRowAction;
@class JTSectionDescriptor;

@interface JTRowDescriptor : JTBaseDescriptor

/** 单元行的标题 */
@property (nonatomic, copy  ) NSString *title;

/** 单元行的tag，不可重复 */
@property (nonatomic, copy  ) NSString *tag;

/** 单元行的值 */
@property (nonatomic, assign) id       value;

/** 单元的高度，如果不设置的话使用默认值 */
@property (nonatomic, assign) CGFloat  height;

/** 单元行没有值时在子label显示的文本，类似于placeholder */
@property (nonatomic, copy  ) NSString *noValueDisplayText;

/** 单元行样式 */
@property (nonatomic, assign) id       cellClass;

@property (nonatomic, weak) JTSectionDescriptor *sectionDescriptor;

/** 单元行的响应Block */
@property (nonatomic, strong) JTRowAction *action;

// 初始化
///||| -----------------------------------

+ (instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title NS_DESIGNATED_INITIALIZER;

///||| --------------------------


@end


@interface JTRowAction : NSObject

@property (nonatomic, copy) void(^rowBlock)(JTRowDescriptor *sender);

@end

NS_ASSUME_NONNULL_END
