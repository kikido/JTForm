//
//  JTForm.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//
#import "JTFormDescriptor.h"
#import "JTSectionDescriptor.h"
#import "JTRowDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@class ASTableNode;
@class ASTableView;

@interface JTForm : UIView 

@property (nonatomic, strong, readonly) ASTableNode *tableNode;

@property (nonatomic, strong, readonly) ASTableView *tableView;

/** 仅支持tail加载。想使用head加载可以自定义‘uirefreshcontrol’或者使用‘mjrefresh’之类的第三方工具 */
@property (nonatomic, weak) id<JTFormTailLoadDelegate> tailDelegate;

@property (nonatomic, weak) id<JTFormEditDeletegate> editDelegate;

@property (nonatomic, weak) id<JTFormDelegate> delegate;

/** 数据源：表描述 */
@property (nonatomic, strong) JTFormDescriptor *formDescriptor;
/** 是否显示‘InputAccessoryView’，default是YES */
@property (nonatomic, assign) BOOL showInputAccessoryView;

- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor;

+ (instancetype)formWithDescriptor:(JTFormDescriptor *)formDescriptor;

#pragma mark - get data

/** 根据tag返回单元行的value。当单元行值类型为`JTOptionObject`时，在返回集合中的值是`JTOptionObject.formValue` */
- (nullable id)findRowValueByTag:(NSString *)tag;


/**
 表单值的集合。key为‘tag’，value为‘value’。
 注意：1. 当value为空时，结果集合中的值为'[nsnull null]'
 ***  2. 如果有一些单元行的‘tag’重复，则仅仅保存其中的一条
 ***  3. 如果是选中类型的单元行，value可能为`JTOptionObject`类型
 ***  4. 隐藏掉的单元行的值也会出现在返回集合中
 */
- (NSDictionary *)formValues;

/**  表单值的集合。key为‘tag’，value为‘value’。与`formValues`不同的是，当单元行值类型为`JTOptionObject`时，在返回集合中的值是`JTOptionObject.formValue` */
- (NSDictionary *)formHttpValues;

#pragma mark - validate

/** 验证表单中某一节的值 */
- (NSArray<NSError *> *)sectionValidationErrors:(JTSectionDescriptor *)sectionDescriptor;

/**
 获得表单的验证错误信息。你可以对单元行设置验证器（id<JTFormValidateProtocol>），如果单元行的值没有通过验证，则会通过该方法返回错误信息。

 @return 未通过验证器验证的错误集合
 */
- (NSArray<NSError *> *)formValidationErrors;

/**
 显示错误信息。当‘form’不在视图层级中时不可使用。

 @param error 错误信息
 */
- (void)showFormValidationError:(NSError *)error;


/**
 显示错误信息。当‘form’不在视图层级中时不可使用。


 @param error 错误信息
 @param title 错误标题
 */
- (void)showFormValidationError:(NSError *)error withTitle:(NSString*)title;


#pragma mark - row types

/**
 一个字典。包含了行描述跟单元行相对应的信息，‘key’为‘rowType’，value为单元行类型。
 当你自定义一个单元行时，你需要在‘+load’方法中为该字典添加新的信息
 */
+ (NSMutableDictionary *)cellClassesForRowTypes;

#pragma mark - inline row types

+ (NSMutableDictionary *)inlineRowTypesForRowTypes;

/** 确保指定行可见 */
- (void)ensureRowIsVisible:(JTRowDescriptor *)rowDescriptor;

#pragma mark - delete && add

- (void)addFormRow:(JTRowDescriptor *)formRow afterRow:(JTRowDescriptor *)afterRow;

-(void)addFormRow:(JTRowDescriptor *)formRow beforeRow:(JTRowDescriptor *)beforeRow;

- (void)addFormRow:(JTRowDescriptor *)formRow afterRowWithTag:(NSString *)afterRowTag;

- (void)addFormRow:(JTRowDescriptor *)formRow beforeRowWithTag:(NSString *)beforeRowTag;

-(void)removeFormRow:(JTRowDescriptor *)row;

-(void)removeFormRowByTag:(NSString *)tag;


#pragma mark - update and reload

/** 根据tag隐藏单元行。调用该方法之后无需刷新即可更新ui */
- (void)setRowsHidden:(BOOL)hidden byTags:(NSArray<NSString *> *)tags;

/** 根据tag设置单元行不可编辑状态，如果需要更新UI则需要手动调用`update`方法 */
- (void)setRowsDisabled:(BOOL)disabled byTags:(NSArray<NSString *> *)tags;

/** 根据tag设置单元行为必填项，如果需要更新UI则需要手动调用`update`方法 */
- (void)setRowsRequired:(BOOL)required byTags:(NSArray<NSString *> *)tags;

/** s根据tag设置value，如果需要更新UI则需要手动调用`update`方法 */
- (void)setRowValue:(nullable id)value byTag:(NSString *)tag;

/** 刷新一定数量的单元行 */
- (void)updateRowByTags:(NSArray<NSString *> *)tags;

/** 刷新单元行的内容 */
- (void)updateFormRow:(JTRowDescriptor *)rowDescriptor;

/** 刷新所有表单上单元行的内容，可以再改变系统字体等操作时使用 */
- (void)updateAllFormRows;

/** 重新加载单元行，将重新创建视图控件 */
- (void)reloadFormRow:(JTRowDescriptor *)rowDescriptor;

/** 重新加载表单，所有控件将重新创建。开销较大 */
- (void)reloadForm;

#pragma mark - edit text delegate

/**
 询问是否可以进入编辑状态

 @param textField ‘UITextField’类实例，可能为空。当这个为空时‘editableTextNode’不能为空
 @param editableTextNode ‘ASEditableTextNode’类实例，可能为空。当这个为空时‘UITextField’不能为空
 */
- (BOOL)editableTextShouldBeginEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode;

/**
 代表开始进入编辑状态
 
 @param textField ‘UITextField’类实例，可能为空。当这个为空时‘editableTextNode’不能为空
 @param editableTextNode ‘ASEditableTextNode’类实例，可能为空。当这个为空时‘UITextField’不能为空
 */
- (void)editableTextDidBeginEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode;

/**  询问是否应在在可编辑文本中替换指定的文本 */
- (BOOL)editableTextNode:(nullable ASEditableTextNode *)editableTextNode textField:(nullable UITextField *)textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

/**  结束编辑状态 */
- (void)editableTextDidEndEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode;

/** 此时单元行进入编辑状态，可以执行一些高亮操作 */
- (void)beginEditing:(JTRowDescriptor *)row;

/** 此时单元行瑞出编辑状态，可以执行一些不高亮操作 */
- (void)endEditing:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
