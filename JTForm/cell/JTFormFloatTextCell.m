//
//  JTFormFloatTextCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormFloatTextCell.h"

@interface JTFormFloatTextCell () <UITextFieldDelegate>
@property (nonatomic, strong) ASDisplayNode *textFieldNode;
@end

@implementation JTFormFloatTextCell

- (void)config
{
    [super config];

    _textFieldNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        JVFloatLabeledTextField *textField = [[JVFloatLabeledTextField alloc] init];
        return textField;
    }];
}

- (void)update
{
    [super update];
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    
    JVFloatLabeledTextField *textField = (JVFloatLabeledTextField *)self.textFieldNode.view;
    _textField = textField;
    textField.delegate        = self;
    textField.enabled         = !self.rowDescriptor.disabled;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font            = [self cellContentFont];
    textField.textColor       = [self cellContentColor];
    textField.attributedPlaceholder =
    [NSAttributedString jt_attributedStringWithString:self.rowDescriptor.placeHolder
                                                 font:[self cellPlaceHolerFont]
                                                color:[self cellPlaceHolerColor]];
    textField.floatingLabel.attributedText = 
    [NSAttributedString jt_attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                                 font:kJTFormFloatTextCellTitltFont
                                                color:[self cellTitleColor]
                                       firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    textField.text = [self.rowDescriptor unEditingText];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.textFieldNode.style.height = ASDimensionMake(40.);
    self.textFieldNode.style.flexGrow = 1.;
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 8., 8., 15.) child:self.textFieldNode];
}

#pragma mark  - responder

- (BOOL)canBecomeFirstResponder
{
    return [super canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    if ([self canBecomeFirstResponder]) {
        return [_textField becomeFirstResponder];
    }
    return false;
}

- (BOOL)isFirstResponder
{
    return [_textField isFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    return [_textField canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self canResignFirstResponder]) {
        return [_textField resignFirstResponder];
    }
    return false;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [[self findForm] textTypeRowShouldBeginEditing:self.rowDescriptor textField:textField editableTextNode:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [[self findForm] textTypeRowShouldChangeTextInRange:range replacementText:string rowDescriptor:self.rowDescriptor textField:textField editableTextNode:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[self findForm] textTypeRowDidBeginEditing:self.rowDescriptor textField:textField editableTextNode:nil];
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    _textField.floatingLabel.attributedText =
    [NSAttributedString jt_attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                                 font:kJTFormFloatTextCellTitltFont
                                                color:[self cellTitleColor]
                                       firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[self findForm] textTypeRowDidEndEditing:self.rowDescriptor textField:textField editableTextNode:nil];
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    _textField.floatingLabel.attributedText =
    [NSAttributedString jt_attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                                 font:kJTFormFloatTextCellTitltFont
                                                color:[self cellTitleColor]
                                       firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
}

@end
