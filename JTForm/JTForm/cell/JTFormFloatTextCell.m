//
//  JTFormFloatTextCell.m
//  JTForm
//
//  Created by dqh on 2019/5/7.
//  Copyright © 2019 dqh. All rights reserved.
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
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
        return textField;
    }];
}

- (void)update
{
    [super update];
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    
    JVFloatLabeledTextField *textField = (JVFloatLabeledTextField *)self.textFieldNode.view;
    textField.backgroundColor = [UIColor yellowColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.enabled = !self.rowDescriptor.disabled;
    textField.font = self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont];
    textField.textColor = self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor];
    textField.attributedPlaceholder = [NSAttributedString
                                       attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                       font:kJTFormFloatTextCellTitltFont
                                       color:[self formCellPlaceHolderColor]
                                       firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    textField.text = [self.rowDescriptor displayContentValue];
    _textField = textField;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.textFieldNode.style.height = ASDimensionMake(40.);
    self.textFieldNode.style.flexGrow = 1.;
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 8., 8., 15.) child:self.textFieldNode];
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
    return [self.findForm editableTextShouldBeginEditing:self.rowDescriptor textField:textField editableTextNode:nil];
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
    [self.findForm editableTextDidBeginEditing:self.rowDescriptor textField:textField editableTextNode:nil];
    if (self.rowDescriptor.valueFormatter) {
        textField.text = [self.rowDescriptor editTextValue];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.rowDescriptor.valueFormatter) {
        textField.text = [self.rowDescriptor displayContentValue];
    }
    [self.findForm editableTextDidEndEditing:self.rowDescriptor textField:textField editableTextNode:nil];
}

@end
