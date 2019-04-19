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

extern CGFloat const JTFormUnspecifiedCellHeight;

@interface JTRowDescriptor : JTBaseDescriptor

/** 单元行的标题 */
@property (nonatomic, copy  ) NSString *title;

/** 单元行的tag，不可重复 */
@property (nonatomic, copy  ) NSString *tag;

/** 单元行样式 */
@property (nonatomic, assign, readonly) NSString *rowType;

/** 单元行的值 */
@property (nullable, nonatomic, assign) id       value;

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

+ (instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;

- (JTBaseCell *)cellInForm;

#pragma mark - cell config


#pragma mark - text

/** 在输入文本的时候也使用文本格式转换 */
@property (nonatomic, assign) BOOL useValueFormatterDuringInput;
/** 文本格式转换，可以将数据格式化为一种易读的格式。‘NSFormatter’是一个抽象类，我们只使用它的子类 */
@property (nullable, nonatomic, strong) NSFormatter *valueFormatter;
/** fixme */
@property (nullable, nonatomic, assign) Class valueTransformer;
/** 内容详情的占位符 */
@property (nullable, nonatomic, copy) NSString *placeHolder;
/** 能输入最大的字符数 */
@property (nullable, nonatomic, assign) NSNumber *maxNumberOfCharacters;


- (nullable NSString *)displayContentValue;

- (nullable NSString *)editTextValue;


@end


@interface JTRowAction : NSObject

@property (nonatomic, copy) void(^rowBlock)(JTRowDescriptor *sender);

@end

NS_ASSUME_NONNULL_END
