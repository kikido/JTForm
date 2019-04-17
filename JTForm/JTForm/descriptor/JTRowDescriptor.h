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
@class JTBaseCell;

extern NSString *const JTFormRowTypeText;
extern NSString *const JTFormRowTypeName;
extern NSString *const JTFormRowTypeEmail;
extern NSString *const JTFormRowTypeNumber;
extern NSString *const JTFormRowTypeInteger;
extern NSString *const JTFormRowTypeDecimal;
extern NSString *const JTFormRowTypePassword;
extern NSString *const JTFormRowTypePhone;
extern NSString *const JTFormRowTypeURL;
extern NSString *const JTFormRowTypeTextView;

@interface JTRowDescriptor : JTBaseDescriptor

/** 单元行的标题 */
@property (nonatomic, copy  ) NSString *title;

/** 单元行的tag，不可重复 */
@property (nonatomic, copy  ) NSString *tag;

/** 单元行样式 */
@property (nonatomic, assign, readonly) NSString *rowType;

/** 单元行的值 */
@property (nonatomic, assign) id       value;

/** 单元的高度，如果不设置的话使用默认值 */
@property (nonatomic, assign) CGFloat  height;

/** 单元行没有值时在子label显示的文本，类似于placeholder */
@property (nonatomic, copy  ) NSString *noValueDisplayText;

@property (nonatomic, weak) JTSectionDescriptor *sectionDescriptor;

/** 单元行的响应Block */
@property (nonatomic, strong) JTRowAction *action;


///|< 配置cell，当JTForm调用update方法后使用
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigAfterUpdate;
///|< 配置cell，当JTForm调用update方法后，且disable属性为Yes时被使用
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigWhenDisabled;
///|< 配置cell，当cell调用config之后，update方法之前调用
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigAtConfigure;
///|< 预留
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellDataDictionary;
/** 数据模型，可为nil */
@property (nonatomic, assign) id mode;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;

- (JTBaseCell *)cellInForm;

#pragma mark - cell config

@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *titleAttribute;

@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *contentAttribute;

@end


@interface JTRowAction : NSObject

@property (nonatomic, copy) void(^rowBlock)(JTRowDescriptor *sender);

@end

@interface JTFormConfigMode : NSObject
@property (nonatomic, strong, nullable) UIColor *titleColor;
@property (nonatomic, strong, nullable) UIColor *contentColor;
@property (nonatomic, strong, nullable) UIColor *placeHolderColor;
@property (nonatomic, strong, nullable) UIColor *disabledTitleColor;
@property (nonatomic, strong, nullable) UIColor *disabledContentColor;

@property (nonatomic, strong, nullable) UIFont *titleFont;
@property (nonatomic, strong, nullable) UIFont *contentFont;
@property (nonatomic, strong, nullable) UIFont *placeHlderFont;
@property (nonatomic, strong, nullable) UIFont *disabledFont;
@property (nonatomic, strong, nullable) UIFont *disabledContentFont;

@end

NS_ASSUME_NONNULL_END
