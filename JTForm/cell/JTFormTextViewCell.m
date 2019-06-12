//
//  JTFormTextFieldCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormTextViewCell.h"

@interface JTFormTextViewCell () <ASEditableTextNodeDelegate, ASTextNodeDelegate>
@property (nonatomic, strong) ASEditableTextNode *textViewNode;
@end

@implementation JTFormTextViewCell

- (void)config
{
    [super config];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _textViewNode = [[ASEditableTextNode alloc] init];
    _textViewNode.delegate = self;
    _textViewNode.scrollEnabled = false;
    _textViewNode.autocorrectionType = UITextAutocorrectionTypeNo;
    _textViewNode.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void)update
{
    [super update];
    
    self.imageNode.image = self.rowDescriptor.image;
    self.imageNode.URL = self.rowDescriptor.imageUrl;
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeInfo]) {
        self.contentNode.attributedText = [NSAttributedString rightAttributedStringWithString:[self.rowDescriptor displayContentValue]
                                                                                     font:[self formCellDisabledContentFont]
                                                                                    color:[self formCellDisabledContentColor]];
    } else {
        _textViewNode.textView.editable = !self.rowDescriptor.disabled;
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment                = NSTextAlignmentRight;
        _textViewNode.typingAttributes = @{
                                           NSFontAttributeName : self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont],
                                           NSForegroundColorAttributeName : self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor],
                                           NSParagraphStyleAttributeName : paragraphStyle
                                           };
        _textViewNode.textView.text = [self.rowDescriptor displayContentValue];
        _textViewNode.attributedPlaceholderText = [NSAttributedString attributedStringWithString:self.rowDescriptor.placeHolder
                                                                                            font:[self formCellDisabledContentFont]
                                                                                           color:[self formCellDisabledContentColor]
                                                                                  firstWordColor:nil];
        _textView = _textViewNode.textView;
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:kJTFormCellImageSpace
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:self.imageNode.hasContent ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    
    ASStackLayoutSpec *rightStack = nil;
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTextView]) {
        _textViewNode.style.alignSelf = ASStackLayoutAlignSelfStretch;
        _textViewNode.style.flexGrow = 2.;
        self.contentNode.style.flexShrink = 1.;
        
        ASLayoutSpec *tempSpec = [ASLayoutSpec new];
        tempSpec.style.minHeight = ASDimensionMake(kJTFormMinTextViewHeight);
        tempSpec.style.width = ASDimensionMake(0.01);
        
        rightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                             spacing:0.
                                                      justifyContent:ASStackLayoutJustifyContentStart
                                                          alignItems:ASStackLayoutAlignItemsStart
                                                            children:@[_textViewNode, tempSpec]];
        rightStack.style.alignSelf = ASStackLayoutAlignSelfStretch;
        rightStack.style.flexGrow = 1.;
    } else {
        self.contentNode.style.minHeight = ASDimensionMake(30.);
        self.contentNode.style.flexGrow = 1.;
        self.contentNode.style.flexShrink = 1.;
    }
    
    self.titleNode.style.flexShrink = 1.;
    self.titleNode.style.flexGrow = 1.;

    leftStack.style.maxWidth = ASDimensionMakeWithFraction(kJTFormTextViewCellMaxTitleWidthFraction);
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems: ASStackLayoutAlignItemsStart
                                                                             children:@[leftStack, rightStack ? rightStack : self.contentNode]];

    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12., 15., 12., 15.) child:contentStack];
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
    [super formCellHighlight];
    _textViewNode.scrollEnabled = YES;
}

- (void)formCellUnhighlight
{
    [super formCellUnhighlight];
    _textViewNode.scrollEnabled = NO;
}

#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    return [self.findForm editableTextShouldBeginEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm editableTextDidBeginEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
    if (self.rowDescriptor.valueFormatter) {
        editableTextNode.textView.text = [self.rowDescriptor editTextValue];
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

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    if (editableTextNode.textView.text.length > 0) {
        self.rowDescriptor.value = editableTextNode.textView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
    if (self.rowDescriptor.valueFormatter) {
        _textViewNode.textView.text = [self.rowDescriptor displayContentValue];
    }
    [self.findForm editableTextDidEndEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

@end
