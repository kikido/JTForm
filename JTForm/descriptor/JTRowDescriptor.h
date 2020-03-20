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

typedef NSString * JTFormRowType;

//|------ textfield ------------------------------
extern JTFormRowType const JTFormRowTypeText;
extern JTFormRowType const JTFormRowTypeName;
extern JTFormRowType const JTFormRowTypeEmail;
extern JTFormRowType const JTFormRowTypeNumber;
extern JTFormRowType const JTFormRowTypeInteger;
extern JTFormRowType const JTFormRowTypeDecimal;
extern JTFormRowType const JTFormRowTypePassword;
extern JTFormRowType const JTFormRowTypePhone;
extern JTFormRowType const JTFormRowTypeURL;

//|------ textview ------------------------------
extern JTFormRowType const JTFormRowTypeTextView;
extern JTFormRowType const JTFormRowTypeInfo;

//|------ select ------------------------------
extern JTFormRowType const JTFormRowTypePushSelect;
extern JTFormRowType const JTFormRowTypeMultipleSelect;
extern JTFormRowType const JTFormRowTypeSheetSelect;
extern JTFormRowType const JTFormRowTypeAlertSelect;
extern JTFormRowType const JTFormRowTypePickerSelect;
extern JTFormRowType const JTFormRowTypePushButton;

//|------ date ------------------------------
/** yyyy mm dd */
extern JTFormRowType const JTFormRowTypeDate;
/** hh mm */
extern JTFormRowType const JTFormRowTypeTime;
/** yyyy mm dd hh mm */
extern JTFormRowType const JTFormRowTypeDateTime;
/** hh mm */
extern JTFormRowType const JTFormRowTypeCountDownTimer;

extern JTFormRowType const JTFormRowTypeDateInline;
extern JTFormRowType const JTFormRowTypeTimeInline;
extern JTFormRowType const JTFormRowTypeDateTimeInline;
extern JTFormRowType const JTFormRowTypeCountDownTimerInline;


//|------ other ------------------------------
extern JTFormRowType const JTFormRowTypeSwitch;
extern JTFormRowType const JTFormRowTypeCheck;
extern JTFormRowType const JTFormRowTypeStepCounter;
extern JTFormRowType const JTFormRowTypeSegmentedControl;
extern JTFormRowType const JTFormRowTypeSlider;
extern JTFormRowType const JTFormRowTypeButton;

//|------ custom ------------------------------
extern JTFormRowType const JTFormRowTypeFloatText;

extern CGFloat const JTFormUnspecifiedCellHeight;


/** 行描述，单元行的数据源。控制着单元行的UI及响应事件 */
@interface JTRowDescriptor : JTBaseDescriptor

/**
 * 单元行标签
 *
 * @note 不可重复
 */
@property (nullable, nonatomic, strong) id<NSCopying> tag;

/** 单元行的值 */
@property (nullable, nonatomic, strong) id value;

/**
 当单元行的 value 变化时执行的 block
 
 @note: 在block内修改该单元行的 value 会造成死循环；还需要注意循环引用的问题
 */
@property (nullable, nonatomic, copy) void(^valueChangeBlock)(_Nullable id oldValue, _Nonnull id newValue, JTRowDescriptor * _Nonnull sender);

/**
 * 单元行是否必录
 *
 * default是 YES
 */
@property (nonatomic, assign) BOOL required;

/**
 * 被包含的节描述
 *
 * @discuss 可能为空，例如被移除或者尚未添加到节上的时候
 */
@property (nullable, nonatomic, weak) JTSectionDescriptor *sectionDescriptor;

/** 响应活动，包括点击事件 */
@property (nonatomic, strong) JTRowAction *action;

/**
 * 数据模型
 *
 * @discuss JTForm 目前并没有用到该属性，该属性适用于列表(即所有单元行样式相同)的情况。
 * 在你自定义的 JTBaseCell 中，你可以根据 mode 来进行 UI 更新等操作。
 */
@property (nullable, nonatomic, strong) id mode;

- (instancetype)init NS_UNAVAILABLE;

/**
 * 创建一个 JTRowDescriptor 实例
 *
 * @discuss 为了创建一个行描述，你必须给定一个 rowType 即单元行样式。tag 可以为空，
 * 但如果你后面还会用到的话建议用 tag 来标记这个单元行
 *
 * @param tag 标签
 * @param rowType 单元行样式。更多类型可以查看 JTFormRowType
 * @param title 单元行标题
 * @return 行描述
 */
- (instancetype)initWithTag:(nullable NSString *)tag rowType:(nonnull JTFormRowType)rowType title:(nullable NSString *)title NS_DESIGNATED_INITIALIZER;

+ (instancetype)rowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull JTFormRowType)rowType title:(nullable NSString *)title;

/**
 * 行描述对应的单元行
 */
- (JTBaseCell *)cellInForm;

@end


//----------------------
/// @name UI
///---------------------
@interface JTRowDescriptor ()

/** 单元行标题 */
@property (nullable, nonatomic, copy) NSString *title;

/**
 * 图片
 *
 * 在 JTForm 中用于单元行标题前面的图片展示
 */
@property (nullable, nonatomic, strong) UIImage *image;

/**
 * 用于加载图片的链接
 *
 * 作用类似于属性 image。优先级 imageUrl > image
 */
@property (nullable, nonatomic, strong) NSURL *imageUrl;

/**
 * 单元行样式
 *
 * @note 生成行描述时即需要制定一个样式以生成对应类型的单元行。
 * 如果有更换单元行样式的需求，可以使用方法 ‘-reloadCellWithNewRowType’
 */
@property (nonnull, nonatomic, copy, readonly) NSString *rowType;

/**
 * 更换单元行样式并重新加载
 *
 * @note 如果仅需要更新 UI，请使用方法 ‘-updateUI’
 *
 * @param rowType 单元行样式
 */
- (void)reloadCellWithNewRowType:(nonnull JTFormRowType)rowType;

/**
 * 单元行的高度
 *
 * 如果不手动设置的话则自动布局
 */
@property (nonatomic, assign) CGFloat height;

/** 配置cell，在 update 方法后使用 */
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigAfterUpdate;
/** 配置cell，在 update 方法后且disabled属性为Yes时使用 */
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigWhenDisabled;
/** 配置cell，当 config 之后，update方法之前调用。仅调用一次 */
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigAtConfigure;
/** 预留，用户可以使用该属性用来操作一些数据 */
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellDataDictionary;

/** 表示行描述对应的单元行是否已经创建 */
@property (nonatomic, assign, readonly, getter=isCellExist) BOOL cellExist;

/**
 * 更新单元行的 UI
 *
 * @note 当行描述对应的单元行尚未创建时，或者单元行从表单中移除后，调用该方法不执行任何操作
 */
- (void)updateUI;

@end


//----------------------
/// @name text
///---------------------
@interface JTRowDescriptor ()

/**
 * 文本转换，将其它类型的值转换成某个格式的文本。
 *
 * 例如数字 100 转换成文本 100.00元，1024 转换成文本 1kb
 */
@property (nullable, nonatomic, strong) NSFormatter *valueFormatter;

/**
 * value 转换器，需要继承 NSValueTransformer
 *
 *
 * @note 该类需要继承于 NSValueTransformer
 * 该类用于将一个类型的值转换为另一种类型的值，在 JTForm 中用于选择项样式的单元行
 */
@property (nullable, nonatomic, assign) Class       valueTransformer;

/**
 * 占位符
 *
 * @discuss 不仅用于 textfield/textview， 还适用于其它样式的单元行
 */
@property (nullable, nonatomic, copy  ) NSString    *placeHolder;

/**
 * 文本样式的单元行所能输入的最大字符数
 *
 * @note 请输入 NSUInteger 类型的数字
 *
 * 适用于 textfield/textview 样式的单元行
 */
@property (nullable, nonatomic, strong) NSNumber    *maxNumberOfCharacters;

/**
 在未编辑状态时显示的内容

 @return 需要在详情 label 显示的文本
 */
- (nullable NSString *)displayTextValue;

/**
 在编辑状态时显示的内容

 @return 需要在详情 label 显示的文本
 */
- (nullable NSString *)editTextValue;

@end


//----------------------
/// @name select
///---------------------
@interface JTRowDescriptor ()
/**
 选择项

 适用于选择样式的单元行
 */
@property (nullable, nonatomic, copy) NSArray<JTOptionObject *> *selectorOptions;

/** 选择时显示的标题 */
@property (nullable, nonatomic, copy) NSString *selectorTitle;

@end


//----------------------
/// @name validate
///---------------------
@interface JTRowDescriptor ()
/** 当单元行为必录项且 value 为空时，自定义的提示信息 */
@property (nullable, nonatomic, copy) NSString *requireMsg;

/** 添加验证器 */
- (void)addValidator:(nonnull id<JTFormValidateProtocol>)validator;

/** 移除验证器 */
- (void)removeValidator:(nonnull id<JTFormValidateProtocol>)validator;

/** 移除所有的验证器 */
- (void)removeAllValidators;

/**
 对单元行的值进行验证

 @discuss 单元行的 value 需要通过所有验证器的验证才算通过
 
 @return 验证结果。验证失败会返回一个 JTFormValidateObject 实例，验证成功在 JTFrorm 均返回 nil
 */
- (nullable JTFormValidateObject *)doValidate;

/**
 判断value是否为空
 
 以下情况均判断为空：
 1. nil
 2. NSNull的实例
 3. 字符串且字符数为0
 4. 数组其count为0
 5. 字典且键值对为0
 */
- (BOOL)rowValueIsEmpty;

@end

@interface JTRowAction : NSObject

/**
 * 关联的 VC
 *
 * 在 JTForm 中，该属性用于选择项样式的单元行 push select，mutable push select。
 * 当你指定了该属性后，将会跳转到该视图控制器中。
 * @note Class 需要实现 JTFormSelectViewControllerDelegate 代理
 */
@property (nullable, nonatomic, assign) Class viewControllerClass;

/**
 * 选中之后执行的 block
 *
 * @note 使用需要注意循环引用的问题
 */
@property (nonatomic, copy) void(^rowBlock)(JTRowDescriptor *sender);

@end

NS_ASSUME_NONNULL_END
