//
//  JTRowDescriptor.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseDescriptor.h"
#import "JTFormValidateObject.h"

NS_ASSUME_NONNULL_BEGIN

@class JTRowAction;
@class JTSectionDescriptor;
@class JTBaseCell;

//|------ textfield ------------------------------
extern NSString *const JTFormRowTypeText;
extern NSString *const JTFormRowTypeName;
extern NSString *const JTFormRowTypeEmail;
/** 数字以及符号 */
extern NSString *const JTFormRowTypeNumber;
extern NSString *const JTFormRowTypeInteger;
extern NSString *const JTFormRowTypeDecimal;
extern NSString *const JTFormRowTypePassword;
extern NSString *const JTFormRowTypePhone;
extern NSString *const JTFormRowTypeURL;

//|------ textview ------------------------------
extern NSString *const JTFormRowTypeTextView;
extern NSString *const JTFormRowTypeInfo;

//|------ select ------------------------------
extern NSString *const JTFormRowTypePushSelect;
extern NSString *const JTFormRowTypeMultipleSelect;
extern NSString *const JTFormRowTypeSheetSelect;
extern NSString *const JTFormRowTypeAlertSelect;
extern NSString *const JTFormRowTypePickerSelect;
extern NSString *const JTFormRowTypePushButton;

//|------ date ------------------------------
extern NSString *const JTFormRowTypeDate;
extern NSString *const JTFormRowTypeTime;
extern NSString *const JTFormRowTypeDateTime;
extern NSString *const JTFormRowTypeCountDownTimer;
extern NSString *const JTFormRowTypeDateInline;

//|------ inline date ------------------------------
extern NSString *const JTFormRowTypeInlineDatePicker;

//|------ other ------------------------------
extern NSString *const JTFormRowTypeSwitch;
extern NSString *const JTFormRowTypeCheck;
extern NSString *const JTFormRowTypeStepCounter;
extern NSString *const JTFormRowTypeSegmentedControl;
extern NSString *const JTFormRowTypeSlider;
extern NSString *const JTFormRowTypeButton;

//|------ custom ------------------------------
extern NSString *const JTFormRowTypeFloatText;

extern CGFloat const JTFormUnspecifiedCellHeight;


/**
 行描述，即单元行的数据源。控制着单元行的UI及响应事件
 */
@interface JTRowDescriptor : JTBaseDescriptor

/** 单元行的标题 */
@property (nonatomic, copy  ) NSString *title;

/** 单元行标题图片 */
@property (nonatomic, strong) UIImage *image;

/** 一个网络连接，用于加载单元行标题图片。优先级 imageUrl > image */
@property (nonatomic, strong) NSURL *imageUrl;

/** 单元行样式 */
@property (nonnull, nonatomic, assign, readonly) NSString *rowType;

/** 单元行的tag，不可重复 */
@property (nonatomic, copy  ) NSString *tag;

/** 单元行的值 */
@property (nullable, nonatomic, strong) id value;

/** 是否为必录项。default是‘YES’ */
@property (nonatomic, assign) BOOL required;

/** 单元行的高度，如果不设置的话则自动布局 */
@property (nonatomic, assign) CGFloat  height;

/** 被包含的节描述。可为空 */
@property (nonatomic, weak) JTSectionDescriptor *sectionDescriptor;

/** 单元行的响应事件 */
@property (nonatomic, strong) JTRowAction *action;

#pragma mark - config

/** 配置cell，在‘update’方法后使用 */
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigAfterUpdate;
/** 配置cell，当'update'方法后，且disabled属性为Yes时被使用 */
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigWhenDisabled;
/** 配置cell，当cell调用config之后，update方法之前调用 */
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigAtConfigure;
/** 预留 */
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellDataDictionary;
/** 数据模型 */
@property (nullable, nonatomic, assign) id mode;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType title:(nullable NSString *)title;

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;


/**
 重新加载所代表的单元行。当‘rowType’变更之后，可以调用该方法，刷新单元行样式。
 */
- (void)reloadCell;


/**
 该行描述所代表的单元行。懒加载
 */
- (JTBaseCell *)cellInForm;

#pragma mark - text

/** 文本格式转换，可以将数据格式化为一种易读的格式。‘NSFormatter’是一个抽象类，我们只使用它的子类，类似'NSDateFormatter'和‘NSNumberFormatter’ */
@property (nullable, nonatomic, strong) NSFormatter *valueFormatter;
/** ‘NSValueTransformer’的子类，用于把一个值转换成另一个值。它指定了可以处理哪类输入，并且合适时甚至支持反向的转换。 */
@property (nullable, nonatomic, assign) Class       valueTransformer;
/** 详情占位符 */
@property (nullable, nonatomic, copy  ) NSString    *placeHolder;
/** 能输入最大的字符数 */
@property (nullable, nonatomic, assign) NSNumber    *maxNumberOfCharacters;

/**
 在未编辑状态时，详情的显示内容
 */
- (nullable NSString *)displayContentValue;

/**
 在编辑状态时，详情的显示内容
 */
- (nullable NSString *)editTextValue;

#pragma mark - select

/** 可以选择的数据 */
@property (nullable, nonatomic, copy) NSArray<JTOptionObject *> *selectorOptions;
/** 选择时的标题 */
@property (nullable, nonatomic, copy) NSString *selectorTitle;

#pragma mark - validate

/** 当‘require’为YES，且value为空时，返回该消息 */
@property (nullable, nonatomic, copy) NSString *requireMsg;

/**
添加验证器
 */
- (void)addValidator:(nonnull id<JTFormValidateProtocol>)validator;

/**
 移除验证器
 */
- (void)removeValidator:(nonnull id<JTFormValidateProtocol>)validator;

/**
 对单元行的值进行验证
 */
- (nullable JTFormValidateObject *)doValidate;


/**
 判断value是否为空，以下情况均判断为空
 1. nil
 2. NSNull的实例
 3. 字符串如果字符数为0
 4. 数组如果为0
 */
- (BOOL)rowValueIsEmpty;

@end


@interface JTRowAction : NSObject

@property (nullable, nonatomic, assign) Class viewControllerClass;

@property (nonatomic, copy) void(^rowBlock)(JTRowDescriptor *sender);

@end

NS_ASSUME_NONNULL_END
