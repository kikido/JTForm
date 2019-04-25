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

//|------ textfield ------------------------------
extern NSString *const JTFormRowTypeText;
extern NSString *const JTFormRowTypeName;
extern NSString *const JTFormRowTypeEmail;
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

//|------ date ------------------------------
extern NSString *const JTFormRowTypeDate;
extern NSString *const JTFormRowTypeTime;
extern NSString *const JTFormRowTypeDateTime;
extern NSString *const JTFormRowTypeCountDownTimer;
extern NSString *const JTFormRowTypeDateInline;

//|------ inline date ------------------------------
extern NSString *const JTFormRowTypeInlineDatePicker;


extern CGFloat const JTFormUnspecifiedCellHeight;

@interface JTRowDescriptor : JTBaseDescriptor

/** 单元行的标题 */
@property (nonatomic, copy  ) NSString *title;

/** 单元行的tag，不可重复 */
@property (nonatomic, copy  ) NSString *tag;

/** 单元行样式 */
@property (nonatomic, assign, readonly) NSString *rowType;

// fixme 感觉修饰符应该是assign
/** 单元行的值 */
@property (nullable, nonatomic, strong) id       value;

/** 是否是必录项 */
@property (nonatomic, assign) BOOL required;

/** 单元的高度，如果不设置的话则自动布局 */
@property (nonatomic, assign) CGFloat  height;

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

+ (instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType title:(nullable NSString *)title;

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;

- (void)reloadCell;

- (JTBaseCell *)cellInForm;

#pragma mark - cell config


#pragma mark - text

/** 文本格式转换，可以将数据格式化为一种易读的格式。‘NSFormatter’是一个抽象类，我们只使用它的子类 */
@property (nullable, nonatomic, strong) NSFormatter *valueFormatter;
/** ‘NSValueTransformer’的子类，用于把一个值转换成另一个值。它指定了可以处理哪类输入，并且合适时甚至支持反向的转换。 */
@property (nullable, nonatomic, assign) Class       valueTransformer;
/** 内容详情的占位符 */
@property (nullable, nonatomic, copy  ) NSString    *placeHolder;
/** 能输入最大的字符数 */
@property (nullable, nonatomic, assign) NSNumber    *maxNumberOfCharacters;

- (nullable NSString *)displayContentValue;

- (nullable NSString *)editTextValue;

#pragma mark - select

// fixme
/** 对于选择行来说，我们需要提前知道可以选择的数据。 */
@property (nullable, nonatomic, copy) NSArray *selectorOptions;

@property (nullable, nonatomic, copy) NSString *selectorTitle;

@end


@interface JTRowAction : NSObject
/** 指定一个vc类，当在‘select’类型或有跳转到其它视图需求的时候可以使用 */
@property (nullable, nonatomic, assign) Class viewControllerClass;

@property (nonatomic, copy) void(^rowBlock)(JTRowDescriptor *sender);

@end

NS_ASSUME_NONNULL_END
