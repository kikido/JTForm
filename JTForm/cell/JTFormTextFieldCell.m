//
//  JTFormTextFieldCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormTextFieldCell.h"

@interface JTFormTextFieldCell () <UITextFieldDelegate>
@property (nonatomic, strong) ASDisplayNode *textFieldNode;
@end

@implementation JTFormTextFieldCell

- (void)config
{
    [super config];
        
    _textFieldNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UITextField *textField = [[UITextField alloc] init];
        return textField;
    }];
}

- (void)update
{
    [super update];
    
    bool isInfo = [self.rowDescriptor.rowType isEqual:JTFormRowTypeInfo];
    UITextField *textField = (UITextField *)self.textFieldNode.view;
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.enabled = !self.rowDescriptor.disabled || isInfo;
    textField.font = isInfo ? [self cellDisabledContentFont] : [self cellContentFont];
    textField.textColor = isInfo ? [self cellDisabledContentColor] : [self cellContentColor];
    textField.textAlignment = NSTextAlignmentRight;
    textField.text = [self.rowDescriptor unEditingText];
    if (!isInfo) {
        textField.attributedPlaceholder =
        [NSAttributedString jt_attributedStringWithString:self.rowDescriptor.placeHolder
                                                     font:[self cellPlaceHolerFont]
                                                    color:[self cellPlaceHolerColor]
                                           firstWordColor:nil];
    }
    _textField = textField;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    NSString *rowType = self.rowDescriptor.rowType;
    if ([rowType isEqualToString:JTFormRowTypeText]) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
//        textField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    else if ([rowType isEqualToString:JTFormRowTypeName]) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([rowType isEqualToString:JTFormRowTypeEmail]) {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([rowType isEqualToString:JTFormRowTypeNumber]) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([rowType isEqualToString:JTFormRowTypeInteger] || [rowType isEqualToString:JTFormRowTypePhone]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([rowType isEqualToString:JTFormRowTypeDecimal]) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([rowType isEqualToString:JTFormRowTypePassword]) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
    }
    else if ([rowType isEqualToString:JTFormRowTypeURL]) {
        textField.keyboardType = UIKeyboardTypeURL;
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.titleNode.style.maxHeight = ASDimensionMake(kJTFormTextFieldCellMaxTitlteHeight);
    self.titleNode.style.flexShrink = 2.;
    
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:kJTFormCellImageSpace
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:self.imageNode.hasContent ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    leftStack.style.flexShrink = 2.;

    _textFieldNode.style.width = ASDimensionMakeWithFraction(.6);
    _textFieldNode.style.height = ASDimensionMake(30.);
    _textFieldNode.style.flexGrow = 1.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems:ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, _textFieldNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

#pragma mark  - responder

- (BOOL)canBecomeFirstResponder
{
    return [super canBecomeFirstResponder] && ![self.rowDescriptor.rowType isEqual:JTFormRowTypeInfo];
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
    return ![self.rowDescriptor.rowType isEqual:JTFormRowTypeInfo] && [[self findForm] textTypeRowShouldBeginEditing:self.rowDescriptor textField:textField editableTextNode:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [[self findForm] textTypeRowShouldChangeTextInRange:range replacementText:string rowDescriptor:self.rowDescriptor textField:textField editableTextNode:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.findForm textTypeRowDidBeginEditing:self.rowDescriptor textField:textField editableTextNode:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.findForm textTypeRowDidEndEditing:self.rowDescriptor textField:textField editableTextNode:nil];
}

@end
