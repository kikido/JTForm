//
//  JTForm.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "JTFormDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@class JTFormDescriptor;
@class JTRowDescriptor;

@interface JTForm : UIView 

@property (nonatomic, strong) ASTableNode *tableNode;

@property (nonatomic, strong) JTFormDescriptor *formDescriptor;

- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor;

#pragma mark - get data

/**
 表单值的集合，即每一个单元行的值的集合。key为‘tag’，value为‘value’。如果有一些单元行的‘tag’重复，则仅仅保存其中的一条。如果‘value’为nil，则返回'[nsnull null]'
 */
- (NSDictionary *)formValues;

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


#pragma mark - row

/**
 一个字典。包含了行描述跟单元行相对应的信息，‘key’为行描述类型，value为单元行类型。
 当你自定义一个单元行时，你需要在‘+load’方法中为该字典添加新的信息
 */
+ (NSMutableDictionary *)cellClassesForRowTypes;

#pragma mark - inline row

+ (NSMutableDictionary *)inlineRowTypesForRowTypes;

- (void)ensureRowIsVisible:(JTRowDescriptor *)rowDescriptor;

#pragma mark - 001
//- (void)didSelectFormRow:(JTRowDescriptor *)rowDescriptor;
//
//- (void)deSelectFormRow:(JTRowDescriptor *)rowDescriptor;

- (void)updateFormRow:(JTRowDescriptor *)rowDescriptor;

- (void)reloadFormRow:(JTRowDescriptor *)rowDescriptor;

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


/**
 询问是否应在在可编辑文本中替换指定的文本

 */
- (BOOL)editableTextNode:(nullable ASEditableTextNode *)editableTextNode textField:(nullable UITextField *)textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

/**
 代表结束进入编辑状态
 
 */
- (void)editableTextDidEndEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode;

- (void)beginEditing:(JTRowDescriptor *)row;

- (void)endEditing:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
