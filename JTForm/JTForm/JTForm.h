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

- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor;

+ (NSMutableDictionary *)cellClassesForRowDescriptorTypes;

+ (NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes;

#pragma mark -


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
