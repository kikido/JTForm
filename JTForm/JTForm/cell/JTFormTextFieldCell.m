//
//  JTFormTextFieldCell.m
//  JTForm
//
//  Created by dqh on 2019/4/17.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormTextFieldCell.h"

@interface JTFormTextFieldCell () <ASEditableTextNodeDelegate, ASTextNodeDelegate, UITextFieldDelegate>

@property (nonatomic, strong) ASDisplayNode *textFieldNode;

@end

@implementation JTFormTextFieldCell

- (BOOL)textNode:(ASTextNode *)textNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point
{
    return YES;
}

- (void)config
{
    [super config];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _textFieldNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UITextField *textField = [[UITextField alloc] init];
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return textField;
    }];
}

- (void)update
{
    [super update];

    UITextField *textField = (UITextField *)self.textFieldNode.view;
    textField.backgroundColor = [UIColor yellowColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeText]) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeName]) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeEmail]) {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeNumber]) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeInteger] || [self.rowDescriptor.rowType isEqualToString:JTFormRowTypePhone]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDecimal]) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePassword]) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeURL]) {
        textField.keyboardType = UIKeyboardTypeURL;
    }
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                 attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                 font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                 color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                 firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    
    textField.font = self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont];
    textField.textColor = self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor];
    textField.textAlignment = NSTextAlignmentRight;
    textField.text = [self.rowDescriptor displayContentValue];
    textField.attributedPlaceholder = [NSAttributedString attributedStringWithString:self.rowDescriptor.placeHolder
                                                                                font:[self formCellDisabledContentFont]
                                                                               color:[self formCellDisabledContentColor]
                                                                      firstWordColor:nil];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10.
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:self.imageNode.image ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    
    _textFieldNode.style.minWidth = ASDimensionMakeWithFraction(.6);
    _textFieldNode.style.height = ASDimensionMake(30.);
    _textFieldNode.style.flexGrow = 1.;
    
    self.titleNode.style.maxHeight = ASDimensionMake(kJTFormTextFieldCellMaxTitlteHeight);
    self.titleNode.style.flexShrink = 2.;
    
    leftStack.style.flexShrink = 2.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems:ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, _textFieldNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

#pragma mark  - responder

- (BOOL)formCellCanBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)formCellBecomeFirstResponder
{
    return [_textFieldNode.view becomeFirstResponder];
}

- (BOOL)formCellResignFirstResponder
{
    return [_textFieldNode.view resignFirstResponder];
}

- (void)formCellHighlight
{
    // fixme
    [super formCellHighlight];
}

- (void)formCellUnhighlight
{
    [super formCellUnhighlight];
}

#pragma mark - Action

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 0) {
        if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeNumber] || [self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDecimal]) {
            self.rowDescriptor.value = [NSDecimalNumber decimalNumberWithString:textField.text locale:NSLocale.currentLocale];
        } else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeInteger]) {
            self.rowDescriptor.value = @([textField.text integerValue]);
        } else {
            self.rowDescriptor.value = textField.text;
        }
    } else {
        self.rowDescriptor.value = nil;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.jtForm editableTextShouldBeginEditing:self.rowDescriptor textField:textField editableTextNode:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.rowDescriptor.maxNumberOfCharacters) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length > self.rowDescriptor.maxNumberOfCharacters.integerValue) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.jtForm editableTextDidBeginEditing:self.rowDescriptor textField:textField editableTextNode:nil];
    if (self.rowDescriptor.valueFormatter) {
        textField.text = [self.rowDescriptor editTextValue];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.rowDescriptor.valueFormatter) {
        textField.text = [self.rowDescriptor displayContentValue];
    }
    [self.jtForm editableTextDidEndEditing:self.rowDescriptor textField:textField editableTextNode:nil];
}

@end
