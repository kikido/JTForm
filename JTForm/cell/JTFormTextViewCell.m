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
        
    _textViewNode = [[ASEditableTextNode alloc] init];
    _textViewNode.delegate = self;
    _textViewNode.scrollEnabled = false;
    _textViewNode.autocorrectionType = UITextAutocorrectionTypeNo;
    _textViewNode.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void)update
{
    [super update];
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeLongInfo]) {
        self.contentNode.attributedText =
        [NSAttributedString jt_rightAttributedStringWithString:[self.rowDescriptor unEditingText]
                                                          font:[self cellDisabledContentFont]
                                                         color:[self cellDisabledContentColor]];
    }
    else {
        _textViewNode.textView.editable = !self.rowDescriptor.disabled;
        _textViewNode.attributedPlaceholderText = [NSAttributedString jt_rightAttributedStringWithString:self.rowDescriptor.placeHolder
                                                                                                    font:[self cellPlaceHolerFont]
                                                                                                   color:[self cellPlaceHolerColor]];
        _textViewNode.attributedText = [NSAttributedString jt_rightAttributedStringWithString:[self.rowDescriptor unEditingText]
                                                                                         font:[self cellContentFont]
                                                                                        color:[self cellContentColor]];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentRight;
        _textViewNode.typingAttributes = @{
            NSForegroundColorAttributeName: [self cellContentColor],
            NSFontAttributeName: [self cellContentFont],
            NSParagraphStyleAttributeName:paragraph
        };
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
    self.titleNode.style.flexShrink = 1.;
    self.titleNode.style.flexGrow = 1.;
    leftStack.style.maxWidth = ASDimensionMakeWithFraction(kJTFormTextViewCellMaxTitleWidthFraction);

    ASStackLayoutSpec *rightStack = nil;
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTextView]) {
        _textViewNode.style.alignSelf = ASStackLayoutAlignSelfStretch;
        _textViewNode.style.flexGrow = 2.;
        _textViewNode.style.flexShrink = 1.;
        
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
        rightStack.style.flexShrink = 1.;
    } else {
        self.contentNode.style.minHeight = ASDimensionMake(30.);
        self.contentNode.style.flexGrow = 1.;
        self.contentNode.style.flexShrink = 1.;
    }
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems: ASStackLayoutAlignItemsStart
                                                                             children:@[leftStack, rightStack ? rightStack : self.contentNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12., 15., 12., 15.) child:contentStack];
}

#pragma mark  - responder

- (BOOL)canBecomeFirstResponder
{
    return (!self.rowDescriptor.disabled && ![self.rowDescriptor.rowType isEqualToString:JTFormRowTypeLongInfo]);
}

- (BOOL)becomeFirstResponder
{
    if ([self canBecomeFirstResponder]) {
        return [_textViewNode becomeFirstResponder];
    }
    return false;
}

- (BOOL)isFirstResponder
{
    return [_textViewNode isFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    return [_textViewNode canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self canResignFirstResponder]) {
        return [_textViewNode resignFirstResponder];
    }
    return false;
}

- (void)cellHighLight
{
    [super cellHighLight];
    _textViewNode.scrollEnabled = YES;
}

- (void)cellUnHighLight
{
    [super cellUnHighLight];
    _textViewNode.scrollEnabled = NO;
}

#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    return [[self findForm] textTypeRowShouldBeginEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    [[self findForm] textTypeRowDidBeginEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [[self findForm] textTypeRowShouldChangeTextInRange:range replacementText:text rowDescriptor:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    [[self findForm] textTypeRowDidEndEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}
@end
