//
//  JTFormTextFieldCell.m
//  JTForm
//
//  Created by dqh on 2019/4/17.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormTextFieldCell.h"

@interface JTFormTextFieldCell () <ASEditableTextNodeDelegate>

@property (nonatomic, strong) JTNetworkImageNode *imageNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASEditableTextNode *textViewNode;

@end

@implementation JTFormTextFieldCell

- (void)config
{
    [super config];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _imageNode = [[JTNetworkImageNode alloc] init];
    _imageNode.layerBacked = YES;
    
    _titleNode = [[ASTextNode alloc] init];
    _titleNode.layerBacked = YES;
    
    _textViewNode = [[ASEditableTextNode alloc] init];
    _textViewNode.delegate = self;
    _textViewNode.style.preferredSize = CGSizeMake(100, 30.);
    _textViewNode.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    _textViewNode.scrollEnabled = YES;
    _textViewNode.textView.textAlignment = NSTextAlignmentRight;
    _textViewNode.backgroundColor = [UIColor blueColor];
}

- (void)update
{
    [super update];
    
    _titleNode.attributedText = [NSAttributedString attributedStringWithString:[NSString stringWithFormat:@"*%@",self.rowDescriptor.title] fontSize:16. color:[UIColor jt_colorWithHexString:@"333333"] firstWordColor:[UIColor redColor]];
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10.
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:_imageNode.image ? @[_imageNode, _titleNode] : @[_titleNode]];
    _textViewNode.style.flexGrow = 1;
    _textViewNode.style.flexShrink = 2.;
    leftStack.style.flexShrink = 1.;
    _titleNode.style.flexShrink = 1.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:15. justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:[self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTextView] ? ASStackLayoutAlignItemsStart : ASStackLayoutAlignItemsCenter children:@[leftStack, _textViewNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    return !self.rowDescriptor.disabled;
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return !self.rowDescriptor.disabled;
}

- (void)editableTextNodeDidChangeSelection:(ASEditableTextNode *)editableTextNode fromSelectedRange:(NSRange)fromSelectedRange toSelectedRange:(NSRange)toSelectedRange dueToEditing:(BOOL)dueToEditing
{
    
}

- (void)editableTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode
{
    
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    
}

@end
