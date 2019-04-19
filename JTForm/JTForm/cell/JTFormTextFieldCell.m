//
//  JTFormTextFieldCell.m
//  JTForm
//
//  Created by dqh on 2019/4/17.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormTextFieldCell.h"

@interface JTFormTextFieldCell () <ASEditableTextNodeDelegate, ASTextNodeDelegate>

@property (nonatomic, strong) JTNetworkImageNode *imageNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASEditableTextNode *textViewNode;
@property (nonatomic, strong) ASDisplayNode *textFieldNode;
/** 需要给textview设定一个最小值，但是因为‘ASDisplayNode.style.minHeight’属性会覆盖‘maxHeight’和‘height’属性，所以使用一个空的node来撑起最小值 */
@property (nonatomic, strong) ASDisplayNode *tempNode;

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
    
    _imageNode = [[JTNetworkImageNode alloc] init];
    _imageNode.layerBacked = YES;
    
    _titleNode = [[ASTextNode alloc] init];
    _titleNode.layerBacked = YES;
    
    _textViewNode = [[ASEditableTextNode alloc] init];
    _textViewNode.textContainerInset = UIEdgeInsetsMake(7, 0, INFINITY, 0);
    _textViewNode.delegate = self;
    _textViewNode.scrollEnabled = false;
    _textViewNode.textView.textAlignment = NSTextAlignmentRight;
    _textViewNode.backgroundColor = [UIColor blueColor];
    _textViewNode.autocorrectionType = UITextAutocorrectionTypeNo;
    _textViewNode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    _textFieldNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UITextField *textField = [[UITextField alloc] init];
        return textField;
    }];
    
    
    // test
    _textViewNode.maximumLinesToDisplay = 1;
    
    _tempNode = [[ASDisplayNode alloc] init];
}

- (void)update
{
    [super update];

    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeText]) {
        _textViewNode.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        _textViewNode.autocorrectionType = UITextAutocorrectionTypeDefault;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeName]) {
        _textViewNode.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeEmail]) {
        _textViewNode.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeNumber]) {
        _textViewNode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeInteger] || [self.rowDescriptor.rowType isEqualToString:JTFormRowTypePhone]) {
        _textViewNode.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDecimal]) {
        _textViewNode.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePassword]) {
        _textViewNode.keyboardType = UIKeyboardTypeASCIICapable;
        _textViewNode.secureTextEntry = YES;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeURL]) {
        _textViewNode.keyboardType = UIKeyboardTypeURL;
    } else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTextView]) {
        _textViewNode.textContainerInset = UIEdgeInsetsZero;
    }
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    _titleNode.attributedText = [NSAttributedString
                                 attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"" : @"*", self.rowDescriptor.title]
                                 font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                 color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                 firstWordColor:required ? UIColorHex(ff3131) : nil];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentRight;
    _textViewNode.typingAttributes = @{
                                       NSFontAttributeName : self.rowDescriptor.disabled ? [self formCellContentFont] : [self formCellDisabledContentFont],
                                       NSForegroundColorAttributeName : self.rowDescriptor.disabled ? [self formCellContentColor] : [self formCellDisabledContentColor],
                                       NSParagraphStyleAttributeName : paragraphStyle
                                       };
    _textViewNode.textView.text = [self.rowDescriptor displayContentValue];
    _textViewNode.attributedPlaceholderText = [NSAttributedString attributedStringWithString:self.rowDescriptor.placeHolder
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
                                                                          children:_imageNode.image ? @[_imageNode, _titleNode] : @[_titleNode]];
    
    ASStackLayoutSpec *rightStack = nil;
    if (![self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTextView]) {
        _titleNode.style.maxHeight = ASDimensionMake(ASDimensionUnitPoints, kJTFormTextFieldCellMaxTitlteHeight);
        _textViewNode.style.minWidth = ASDimensionMake(ASDimensionUnitPoints, 120.);
        _textViewNode.style.height = ASDimensionMake(ASDimensionUnitPoints, 30.);
        
    } else {
        _titleNode.style.maxWidth = ASDimensionMake(ASDimensionUnitPoints, kJTFormTextViewCellMaxTitleWidth);
        _textViewNode.style.alignSelf = ASStackLayoutAlignSelfStretch;
        
        _tempNode.style.minHeight = ASDimensionMake(110.);
        _tempNode.style.width = ASDimensionMake(0.01);
        rightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                             spacing:0.
                                                      justifyContent:ASStackLayoutJustifyContentStart
                                                          alignItems:ASStackLayoutAlignItemsStart
                                                            children:@[_textViewNode, _tempNode]];
        rightStack.style.alignSelf = ASStackLayoutAlignSelfStretch;
        rightStack.style.flexGrow = 1.;
    }
    
    _titleNode.style.flexShrink = 1.;
    leftStack.style.flexShrink = 1.;
    _textViewNode.style.flexGrow = 1.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:15. justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:[self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTextView] ? ASStackLayoutAlignItemsStart : ASStackLayoutAlignItemsCenter children:@[leftStack, rightStack ? rightStack : _textViewNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

#pragma mark  -

- (BOOL)formCellCanBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)formCellBecomeFirstResponder
{
    return [_textViewNode becomeFirstResponder];
}

- (BOOL)formCellResignFirstResponder
{
    return [_textViewNode resignFirstResponder];
}

- (void)formCellHighlight
{
    // fixme
    [super formCellHighlight];
//    _textViewNode.scrollEnabled = YES;
}

- (void)formCellUnhighlight
{
    [super formCellUnhighlight];
//    [_textViewNode.textView scrollRangeToVisible:NSMakeRange(0, 1)];
//    _textViewNode.scrollEnabled = false;
}

#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    return [self.jtForm editableTextNodeShouldBeginEditing:editableTextNode];
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    [self.jtForm beginEditing:self.rowDescriptor];
    [self.jtForm editableTextNodeDidBeginEditing:editableTextNode];
    if (self.rowDescriptor.valueFormatter) {
        _textViewNode.textView.text = [self.rowDescriptor editTextValue];
    }
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.rowDescriptor.maxNumberOfCharacters) {
        NSString *newString = [editableTextNode.textView.text stringByReplacingCharactersInRange:range withString:text];
        if (newString.length > [self.rowDescriptor.maxNumberOfCharacters integerValue]) {
            return NO;
        }
    }
    return YES;
}

- (void)editableTextNodeDidChangeSelection:(ASEditableTextNode *)editableTextNode fromSelectedRange:(NSRange)fromSelectedRange toSelectedRange:(NSRange)toSelectedRange dueToEditing:(BOOL)dueToEditing
{
   
}

- (void)editableTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode
{
    if (editableTextNode.textView.text.length > 0) {
        BOOL didUseFormatter = NO;
        
        if (self.rowDescriptor.valueFormatter && self.rowDescriptor.useValueFormatterDuringInput) {
            NSString *errorDescription = nil;
            NSString *objectValue = nil;
            
            if ([self.rowDescriptor.valueFormatter getObjectValue:&objectValue forString:editableTextNode.textView.text errorDescription:&errorDescription]) {
                if (!errorDescription) {
                    NSString *formatterValue = [self.rowDescriptor.valueFormatter stringForObjectValue:objectValue];
                    self.rowDescriptor.value = objectValue;
                    editableTextNode.textView.text = formatterValue;
                    didUseFormatter = YES;
                }
            }
        }
        if (didUseFormatter) {
            if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeNumber] || [self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDecimal]) {
                self.rowDescriptor.value = [NSDecimalNumber decimalNumberWithString:editableTextNode.textView.text locale:NSLocale.currentLocale];
            } else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeInteger]) {
                self.rowDescriptor.value = @([editableTextNode.textView.text integerValue]);
            } else {
                self.rowDescriptor.value = editableTextNode.textView.text;
            }
        }
    } else {
        self.rowDescriptor.value = nil;
    }
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    if (self.rowDescriptor.valueFormatter) {
        _textViewNode.textView.text = [self.rowDescriptor displayContentValue];
    }
    [self.jtForm endEditing:self.rowDescriptor];
    [self.jtForm editableTextNodeDidFinishEditing:editableTextNode];
}

@end
